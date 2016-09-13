//
//  SignInViewModel.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

class SignInViewModel {
    
    //MARK: - Properties
    
    let emailText = MutableProperty<String>("")
    let passwordText = MutableProperty<String>("")
    let enabledSignInButton = MutableProperty<Bool>(false)
    var buttonSignInPressSignal :RACSignal? {
        didSet {
            buttonSignInSignalConfigurate()
        }
    }
    var buttonSignUpPressSignal :RACSignal? {
        didSet {
            buttonSignUpSignalConfigurate()
        }
    }
    
    
    private let authManager: AuthManager
    
    //MARK: - Initialization
    
    init(authManager: AuthManager) {
        self.authManager = authManager
        enabledSignInButton <~ enabledOnVerify()
    }
    
    //MARK: - AuthMethod
    
    func buttonSignInSignalConfigurate() {
        buttonSignInPressSignal!.subscribeNext({ (anyObject) in
            self.authManager
                .signalForAuthByEmail(self.emailText.value, password: self.passwordText.value)
                .on(failed: { (error) in router().displayAlertTitle("Error", message: "please check emain and password") },
                    next: { (userAuth) in router().showBlogTabBarController() })
                .start()
        })
    }
    
    //MARK: - Switch to SignUp controller
    
    func buttonSignUpSignalConfigurate() {
        buttonSignUpPressSignal!.subscribeNext({ (anyObject) in
            router().showSignUpController()
            print("Button SignUp pressed")
        })
    }
    
    //MARK: - Verification
    
    func enabledOnVerify() -> Signal<Bool, NoError> {
        return combineLatest(emailVerifSignal(), passVerifSignal())
            .map { $0 == true && $1 == true}
    }
    
    func emailVerifSignal() -> Signal<Bool, NoError> {
        return emailText.signal.map({ stringIsValidEmail($0) })
    }
    
    func passVerifSignal() -> Signal<Bool, NoError> {
        return passwordText.signal.map({ $0.characters.count > 3 })
    }
}
