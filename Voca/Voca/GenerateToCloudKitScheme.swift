//
//  GenerateToCloudKitScheme.swift
//  Vocabulary
//
//  Created by user on 2020/07/28.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import CoreData
import CloudKit

// NOTICE
// 상관 없는 코드
// 로컬에서 만든 coredat가 cloudkit 의 dashboard scheme 로 업데이트가 되는 Test 용

@available(iOS 13.0, *)
public class VocaCoreDataManager {
    public static let shared = VocaCoreDataManager()
    let modelName = "Voca"
    let cloudKitID = "iCloud.Spark.Vocabulary"
    let vocaBundleID = "Spark.Voca"

    public init() {
        _ = persistentContainer

        // add test
        let data = ManagedGroup(context: persistentContainer.viewContext)

        data.title = "테스트용 타이틀"

        do {
            try persistentContainer.viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }


        //2
        let fetchRequest =
            NSFetchRequest<ManagedGroup>(entityName: "Group")

        //3
        do {
            let data = try persistentContainer.viewContext.fetch(fetchRequest)
            print(data)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }


    }

    lazy var persistentContainer: NSPersistentContainer = {
        // vaca data model 을 다른 target에 생성했기 때문에 bundle을 직접 명시
        let vocaBundle = Bundle(identifier: vocaBundleID)
        let modelURL = vocaBundle!.url(forResource: modelName, withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)

        // MARK: - NSPersistentContainer to NSPersistentCloudKitContainer for CloudKit ☁️
        let container = NSPersistentCloudKitContainer(name: modelName, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (storeDescription, error) in

            if let err = error{
                fatalError("❌ Loading of store failed:\(err)")
            }
        }

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

