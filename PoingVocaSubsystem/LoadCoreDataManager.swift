//
//  LoadCoreDataManager.swift
//  PoingVocaSubsystem
//
//  Created by LEE HAEUN on 2020/08/23.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//
// Voca의 default(기본 폴더)가 여러개 생기지 않도록 하기 위해
// 유저가 다른기기에서 앱을 실행하거나, 앱을 삭제 후 다시 설치한 경우를 확인하기 위해
// 앱을 load한적이 있는지 확인


import CoreData
import CloudKit

public class LoadCoreDataManager {
    let cloudKitID = "iCloud.Spark.LoadTime"
    let privateDataBase: CKDatabase
    public static let shared = LoadCoreDataManager()
    let recordType = "Load"

    public init() {
        privateDataBase = CKContainer(identifier: cloudKitID).privateCloudDatabase
    }

    public func fetchLoad() {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))

        privateDataBase.perform(query, inZoneWith: nil) { (record, error) in
            guard error == nil else { return }

            if record?.isEmpty ?? true {
                self.insertDefaultGroup()
            }
        }
    }

    func insertDefaultGroup() {
        guard hasLoadTimeForUnavailableUser == nil else {
            return
        }

        VocaManager.shared.insertDefaultGroup {
            self.insertTime()
        }
    }

    func insertTime() {
        let record = CKRecord(recordType: recordType)
        record.setObject(Date() as CKRecordValue?, forKey: "Time")
        privateDataBase.save(record) { (record, error) in
            print(record)
            print(error)
        }
    }

    public func deleteLoadTime(record: CKRecord) {
        privateDataBase.delete(withRecordID: record.recordID) { (recordId, error) in
            print(recordId)
            print(error)

            self.fetchLoad()
        }
    }
}

// MARK: - User Defaults
extension LoadCoreDataManager {
    private var hasLoadTimeForUnavailableUserKey: String {
        "hasLoadTimeForUnavailableUserKey"
    }

    var hasLoadTimeForUnavailableUser: Date? {
        get {
            UserDefaults.standard.object(forKey: hasLoadTimeForUnavailableUserKey) as? Date
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: hasLoadTimeForUnavailableUserKey)
        }
    }

    public func insertDefaultGroupForUnavailableiCloudUser() {
        VocaManager.shared.fetch(identifier: nil) { (groups) in
            guard groups?.isEmpty ?? true else {
                return
            }

            VocaManager.shared.insertDefaultGroup {
                self.hasLoadTimeForUnavailableUser = Date()
            }
        }
    }
}
