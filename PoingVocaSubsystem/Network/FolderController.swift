//
//  FolderController.swift
//  PoingVocaSubsystem
//
//  Created by LEE HAEUN on 2020/09/17.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import RxSwift
import Moya

extension Notification.Name {
    public static let myFolder = Notification.Name("MyFolder")
}

public class FolderManager {
    public static let shared = FolderManager()

    public var myFolders: [Folder] = [] {
        didSet {
            NotificationCenter.default.post(
                name: Notification.Name.myFolder,
                object: nil
            )
        }
    }
}

public class FolderController {
    public static let shared = FolderController()
    private let serviceManager = FolderServiceManager()

    public func getMyFolder() -> Observable<[Folder]> {
        return serviceManager.provider.rx
            .request(FolderService.getMyFolder)
            .map([Folder].self)
            .asObservable()
    }

    public func addFolder(name: String, shareable: Bool = true) -> Observable<Response> {
        return serviceManager.provider.rx
            .request(FolderService.addFolder(name: name, shareable: shareable))
            .asObservable()
    }

    public func deleteFolder(folderId: [Int]) -> Observable<Response> {
        return serviceManager.provider.rx
            .request(FolderService.deleteFolder(folderId: folderId))
            .asObservable()
    }

    public func editFolder(folderId: Int, name: String, shareable: Bool = true) -> Observable<Response> {
        return serviceManager.provider.rx
            .request(FolderService.editFolder(folderId: folderId, name: name, shareable: shareable))
            .asObservable()
    }

    public func reorderFolder(folderIds: [Int]) -> Observable<Response> {
        return serviceManager.provider.rx
            .request(FolderService.reorderFolder(folderIds: folderIds))
            .asObservable()
    }
}
