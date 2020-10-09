//
//  VocaCoreDataManager.swift
//  Voca
//
//  Created by user on 2020/07/28.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import CoreData
import CloudKit

public class VocaCoreDataManager: NSObject {
    public static let shared = VocaCoreDataManager()
    let modelName = "Voca"
    let cloudKitID = "iCloud.Spark.Vocabularya"
    let vocaBundleID = "Spark.PoingVocaSubsystem"

    /**
     An operation queue for handling history processing tasks: watching changes, deduplicating tags, and triggering UI updates if needed.
     */
    private lazy var historyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        // MARK: - vaca data model 을 다른 target에 생성했기 때문에 bundle을 직접 명시
        let vocaBundle = Bundle(identifier: vocaBundleID)
        let modelURL = vocaBundle!.url(forResource: modelName, withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)

        // MARK: - NSPersistentContainer to NSPersistentCloudKitContainer for CloudKit ☁️
        let container = NSPersistentCloudKitContainer(name: modelName, managedObjectModel: managedObjectModel!)

        // Enable history tracking and remote notifications
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        container.viewContext.transactionAuthor = appTransactionAuthorName

        // Pin the viewContext to the current generation token and set it to keep itself up to date with local changes.
        container.viewContext.automaticallyMergesChangesFromParent = true
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("###\(#function): Failed to pin viewContext to the current generation:\(error)")
        }

        // Observe Core Data remote change notifications.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(type(of: self).storeRemoteChange(_:)),
            name: .NSPersistentStoreRemoteChange,
            object: container
        )

        // 아래부터는 Configurations load
        // Put our stores into Application Support
        var storePath: URL
        do {
            storePath = try FileManager.default.url(for: .applicationSupportDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: true)
        } catch {
            fatalError("Unable to get path to Application Support directory")
        }

        // Ref,  https://developer.apple.com/documentation/coredata/mirroring_a_core_data_store_with_cloudkit/setting_up_core_data_with_cloudkit

        // Create a store description for a local store
        let localStoreLocation = storePath.appendingPathComponent("local.store")
        let localStoreDescription =
            NSPersistentStoreDescription(url: localStoreLocation)
        localStoreDescription.configuration = "Local"

        // Create a store descpription for a CloudKit-backed local store
        let cloudStoreLocation = storePath.appendingPathComponent("cloud.store")
        let cloudStoreDescription =
            NSPersistentStoreDescription(url: cloudStoreLocation)
        cloudStoreDescription.configuration = "Cloud"

        // Set the container options on the cloud store
        cloudStoreDescription.cloudKitContainerOptions =
            NSPersistentCloudKitContainerOptions(
                containerIdentifier: cloudKitID)

        // Update the container's list of store descriptions
        container.persistentStoreDescriptions = [
            cloudStoreDescription,
            localStoreDescription
        ]

        // Load both stores
        container.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError("Could not load persistent stores. \(error!)")
            }
        }

        return container
    }()

    var backgroundContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    public override init() {
        super.init()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextObjectDidChange(_:)),
            name: .NSManagedObjectContextObjectsDidChange,
            object: persistentContainer.viewContext
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchChanges),
            name: .NSPersistentStoreRemoteChange,
            object: persistentContainer.persistentStoreCoordinator
        )

    }

    func performBackgroundTask(_ completion: @escaping (NSManagedObjectContext) -> Void) {
        let context = backgroundContext
        context.perform { () -> Void in
            completion(context)
        }
    }

    func saveContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetch(predicate identifier: UUID?, context: NSManagedObjectContext) -> [ManagedGroup]? {
        let fetchRequest =
            NSFetchRequest<ManagedGroup>(entityName: "Group")

        if let identifier = identifier {
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier as CVarArg)
            fetchRequest.fetchLimit = 1
        }

        guard let groupList = try? context.fetch(fetchRequest),
            groupList.isEmpty == false else {
                return nil
        }
        return groupList
    }

    func fetch(
        predicate visibilityType: VisibilityType,
        context: NSManagedObjectContext
    ) -> [ManagedGroup]? {
        let fetchRequest =
            NSFetchRequest<ManagedGroup>(entityName: "Group")

        fetchRequest.predicate = NSPredicate(format: "visibilityType == %@", visibilityType.rawValue)

        guard let groupList = try? context.fetch(fetchRequest),
            groupList.isEmpty == false else {
                return nil
        }
        return groupList
    }

    func insert(group: FolderCoreData, context: NSManagedObjectContext) {
        group.toManaged(context: context)
        saveContext(context: context)
    }

    func delete(identifier: UUID, context: NSManagedObjectContext) {
        guard let deleteGroups = fetch(predicate: identifier, context: context) else {
            return
        }

        for deleteGroup in deleteGroups {
            context.delete(deleteGroup)
        }
        saveContext(context: context)
    }

    func update(group: FolderCoreData, context: NSManagedObjectContext, completion: @escaping (() -> Void)) {
        guard let updateGroups = fetch(predicate: group.identifier, context: context) else {
            completion()
            return
        }

        for updateGroup in updateGroups {
            updateGroup.title = group.name
            updateGroup.visibilityType = group.visibilityType.rawValue
            var newWordArr = [ManagedWord]()
            for word in group.words {
                newWordArr.append(word.toManaged(context: context))
            }
            updateGroup.words = NSSet(array: newWordArr)
        }        
        saveContext(context: context)
        completion()
    }
    
    public func reset() {
        let container = persistentContainer
        let coordinator = container.persistentStoreCoordinator
        if let store = coordinator.destroyPersistentStore(type: NSSQLiteStoreType) {
            do {
                try coordinator.addPersistentStore(
                    ofType: NSSQLiteStoreType,
                    configurationName: nil,
                    at: store.url,
                    options: nil
                )
            } catch {
                print(error)
            }
        }
    }

    @objc private func contextObjectDidChange(_ notification: NSNotification) {
        NotificationCenter.default.post(name: .vocaDataChanged, object: self)
    }

    @objc func fetchChanges(_ notification: NSNotification) {
        print("###\(#function): fetchChange.")
    }
}

// MARK: - Notifications

extension VocaCoreDataManager {
    /**
     Handle remote store change notifications (.NSPersistentStoreRemoteChange).
     merge 공부중임
     */
    @objc
    func storeRemoteChange(_ notification: Notification) {
        print("###\(#function): Merging changes from the other persistent store coordinator.")

        print(fetch(predicate: .default, context: backgroundContext))
        // Process persistent history to merge changes from other coordinators.
        historyQueue.addOperation {
//            self.processPersistentHistory()
        }
    }
}

extension NSPersistentStoreCoordinator {
    func destroyPersistentStore(type: String) -> NSPersistentStore? {
        guard
            let store = persistentStores.first(where: { $0.type == type }),
            let storeURL = store.url
            else {
                return nil
        }

        try? destroyPersistentStore(at: storeURL, ofType: store.type, options: nil)

        return store
    }
}

/* debug first time
 CoreData: debug: CoreData+CloudKit: -[PFCloudKitOptionsValidator validateOptions:andStoreOptions:error:](35): Validating options: <NSCloudKitMirroringDelegateOptions: 0x6000000bcf00> containerIdentifier:iCloud.Spark.Vocabulary ckAssetThresholdBytes:<null> operationMemoryThresholdBytes:<null> useEncryptedStorage:NO useDeviceToDeviceEncryption:NO automaticallyDownloadFileBackedFutures:NO automaticallyScheduleImportAndExportOperations:YES skipCloudKitSetup:NO preserveLegacyRecordMetadataBehavior:NO useDaemon:YES apsConnectionMachServiceName:<null> containerProvider:<PFCloudKitContainerProvider: 0x600002c94930> storeMonitorProvider:<PFCloudKitStoreMonitorProvider: 0x600002c94960> metricsClient:<PFCloudKitMetricsClient: 0x600002c94970> metadataPurger:<PFCloudKitMetadataPurger: 0x600002c94980> scheduler:<null> notificationListener:<null> containerOptions:<null>
 storeOptions: {
 NSInferMappingModelAutomaticallyOption = 1;
 NSMigratePersistentStoresAutomaticallyOption = 1;
 NSPersistentCloudKitContainerOptionsKey = "<NSPersistentCloudKitContainerOptions: 0x600002eed100>";
 NSPersistentHistoryTrackingKey = 1;
 NSPersistentStoreMirroringOptionsKey =     {
 NSPersistentStoreMirroringDelegateOptionKey = "<NSCloudKitMirroringDelegate: 0x60000198d1e0>";
 };
 }
 CoreData: CloudKit: CoreData+CloudKit: -[NSCloudKitMirroringDelegate _setUpCloudKitIntegration](417): <NSCloudKitMirroringDelegate: 0x60000198d1e0>: Successfully enqueued setup request.
 CoreData: CloudKit: CoreData+CloudKit: -[NSCloudKitMirroringDelegate checkAndExecuteNextRequest](2077): <NSCloudKitMirroringDelegate: 0x60000198d1e0>: Checking for pending requests.
 CoreData: debug: CoreData+CloudKit: -[NSCloudKitMirroringDelegate checkAndExecuteNextRequest]_block_invoke(2097): Unable to schedule work because the mirroring delegate was deallocated.
 */

