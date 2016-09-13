//
//  SignInViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class SignInViewController: UIViewController {
    
    var mainView : SignInView? {
        return self.view as? SignInView
    }
    var viewModel: SignInViewModel = SignInViewModel(authManager: AuthManager.sharedInstance)
    
    //MARK: - Loading View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindProperties()
    }
    
    //MARK: - Bindings
    
    func bindProperties() {
        mainView!.passwordField.rac_secureTextEntry <~ mainView!.switchView.rac_newOnChannel
        mainView!.signInButton.rac_enabled <~ viewModel.enabledSignInButton
        viewModel.emailText <~ mainView!.emailField.rac_textKB
        viewModel.passwordText <~ mainView!.passwordField.rac_textKB
        viewModel.buttonSignInPressSignal = self.mainView?.signInButton.rac_buttonTouchUpInside
        viewModel.buttonSignUpPressSignal = self.mainView?.signUnButton.rac_buttonTouchUpInside
    }
}
