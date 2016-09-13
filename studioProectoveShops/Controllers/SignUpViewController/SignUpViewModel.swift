//
//  SignUpViewModel.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

class SignUpViewModel {
    
    //MARK: - Properties
    
    let usernameText = MutableProperty<String>("")
    let emailText = MutableProperty<String>("")
    let passwordText = MutableProperty<String>("")
    let confirmPasswordText = MutableProperty<String>("")
    let enabledSignUpButton = MutableProperty<Bool>(false)
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
        enabledSignUpButton <~ enabledOnVerify()
    }

    //MARK: - AuthMethod Registration
    
    func buttonSignUpSignalConfigurate() {
        buttonSignUpPressSignal!.subscribeNext({ (anyObject) in
            self.authManager
                .signalForRegisterUserByEmail(self.emailText.value,
                    password: self.passwordText.value,
                    userName: "dsfs")
                .on(failed: { (error) in router().displayAlertTitle("Error", message: "please check internet connection") },
                    next: { (user) in router().showBlogTabBarController() })
                .start()
        })
    }
    
    //MARK: - Switch to SignIn controller
    
    func buttonSignInSignalConfigurate() {
        buttonSignInPressSignal!.subscribeNext({ (anyObject) in
            router().showSignInController()
            print("Button SignIn pressed")
        })
    }
    
    //MARK: - Verification
    
    func enabledOnVerify() -> Signal<Bool, NoError> {
        return combineLatest(usernameVerifSignal(), emailVerifSignal(), passVerifSignal(), confirmPassVerifSignal())
            .map { $0 == true && $1 == true && $2 == true && $3 == true }
    }
    
    func usernameVerifSignal() -> Signal<Bool, NoError> {
        return usernameText.signal.map({ $0.characters.count > 3 })
    }
    
    func emailVerifSignal() -> Signal<Bool, NoError> {
        return emailText.signal.map({ stringIsValidEmail($0) })
    }
    
    func passVerifSignal() -> Signal<Bool, NoError> {
        return passwordText.signal.map({ $0.characters.count > 3 })
    }
    
    func confirmPassVerifSignal() -> Signal<Bool, NoError> {
        return passwordText.signal.map({ $0 == self.passwordText.value })
    }
}
