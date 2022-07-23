//
//  AppleLogin.swift
//  PlugSpace
//
//  Created by MAC on 20/12/21.
//

import Foundation
import AuthenticationServices

@available(iOS 13.0, *)
class AppleData : NSObject {
    
    //MARK:- Properties
    
      static let shared = AppleData()
      private let appleIDProvider = ASAuthorizationAppleIDProvider()
      var isLogin = false
      private let viewModel = SignUPVM()
      private let viewLoginModel = LoginVM()

    //MARK:-
    
    //MARK:- Method
    
        func loginWithApple() {

            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
        
//        func getCredentialState()  {
//
//            appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) {  (credentialState, error) in
//                 switch credentialState {
//                    case .authorized:
//                        // The Apple ID credential is valid.
//                        break
//                    case .revoked:
//                        // The Apple ID credential is revoked.
//                        break
//                    case .notFound:
//                        // No credential was found, so show the sign-in UI.
//                        break
//                    default:
//                        break
//                 }
//            }
//        }
}

//MARK:- Apple Login

// MARK: - ASAuthorizationController Delegate
@available(iOS 13.0, *)
extension AppleData: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                let userIdentifier = appleIDCredential.user
                
                viewLoginModel.isApple = "1"
                viewLoginModel.appleId = userIdentifier
                SignUPVM.shared.appleId = userIdentifier
                SignUPVM.shared.isApple = "1"
                viewLoginModel.isInsta = "0"
                viewLoginModel.instaId = "0"
                viewModel.delegate = self
                viewModel.delegate?.instaLoginProcessCompleted(isSuccess: true)
                
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    
    private func saveUserInKeychain(_ userIdentifier: String) {
//        do {
//            try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
//        } catch {
//            print("Unable to save userIdentifier to keychain.")
//        }
    }
    
    private func showResultViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
//        guard let viewController = self.presentingViewController as? ResultViewController
//            else { return }
//
//        DispatchQueue.main.async {
//            viewController.userIdentifierLabel.text = userIdentifier
//            if let givenName = fullName?.givenName {
//                viewController.givenNameLabel.text = givenName
//            }
//            if let familyName = fullName?.familyName {
//                viewController.familyNameLabel.text = familyName
//            }
//            if let email = email {
//                viewController.emailLabel.text = email
//            }
//            self.dismiss(animated: true, completion: nil)
//        }
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.present(alertController, animated: true, completion: nil)
    }
    
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}


// MARK: - ASAuthorizationControllerPresentationContextProviding
@available(iOS 13.0, *)
extension AppleData: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ((appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.view.window!)!
    }
}

@available(iOS 13.0, *)
extension AppleData: SignUpVMDelegate {
    
    func instaSignupProcessCompleted(isSuccess: Bool) {
      
    }
    
    func instaLoginProcessCompleted(isSuccess: Bool) {
        (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.view.endEditing(true)
        if isSuccess {
            
            viewLoginModel.isRegister { [self] (isSuccess) in
                
                if isSuccess {
                    appdelegate.goToHomeVc()
                    AppPrefsManager.shared.setIsUserLogin(isUserLogin: true)
                } else {
                    if viewLoginModel.errorMessage.contains("user is not registered") {
                        (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.pushVC(GenderVC.self)
                    } else {
                     (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.alertWith(message: viewLoginModel.errorMessage)
                    }
                }
            }
        } else {
             (appdelegate.window!.rootViewController! as! UINavigationController).viewControllers.last?.alertWith(message: viewLoginModel.errorMessage)
        }
    }
}
