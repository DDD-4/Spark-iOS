//
//  AppleLoginHelper.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/09/13.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import AuthenticationServices

protocol LoginDelegate: class {
    func login(userIdentifier: String, name: String)
}
class AppleLoginHelper: NSObject {
    weak var loginDelegate: LoginDelegate?

    static let shared = AppleLoginHelper()

    deinit {
        print("AppleLoginHelper deinit")
    }

    func setDelegate(_ loginDelegate: LoginDelegate) {
        self.loginDelegate = loginDelegate
    }

    func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension AppleLoginHelper: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let name = (appleIDCredential.fullName?.familyName ?? "") + (appleIDCredential.fullName?.givenName ?? "")
            self.loginDelegate?.login(userIdentifier: userIdentifier, name: name)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //Handle error here
        print(error.localizedDescription)
    }

}
