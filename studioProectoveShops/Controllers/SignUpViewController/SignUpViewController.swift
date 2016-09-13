//
//  SignUpViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class SignUpViewController: UIViewController, UITextFieldDelegate {

    var mainView : SignUpView? {
        return self.view as? SignUpView
    }
    var viewModel: SignUpViewModel = SignUpViewModel(authManager: AuthManager.sharedInstance)
    
    var textFields : Array <UITextField!> {
        return [mainView?.userNameTextField, mainView?.emailTextField, mainView?.passwordTextField, mainView?.confPassTextField]
    }
    
    //MARK: - Loading View
    
    override func viewDidLoad() {
        bindProperties()
        textFieldReturnButton()
    }
    
    override func viewDidDisappear(animated: Bool) {
        clearTextFields()
    }
    
    //MARK: - Private
    
    private func clearTextFields() {
        self.textFields.forEach { $0.text = "" }
    }
    
    //MARK: - Bindings
    
    func bindProperties() {
        mainView!.passwordTextField.rac_secureTextEntry <~ mainView!.switchView.rac_newOnChannel
        mainView!.confPassTextField.rac_secureTextEntry <~ mainView!.switchView.rac_newOnChannel
        mainView!.signUpButton.rac_enabled <~ viewModel.enabledSignUpButton
        
        viewModel.usernameText <~ mainView!.userNameTextField.rac_textKB
        viewModel.emailText <~ mainView!.emailTextField.rac_textKB
        viewModel.passwordText <~ mainView!.passwordTextField.rac_textKB
        viewModel.confirmPasswordText <~ mainView!.confPassTextField.rac_textKB
        viewModel.buttonSignInPressSignal = self.mainView?.signInButton.rac_buttonTouchUpInside
        viewModel.buttonSignUpPressSignal = self.mainView?.signUpButton.rac_buttonTouchUpInside
    }
    
    func textFieldReturnButton() {
        for (index, value) in textFields.enumerate() {
            value!.rac_keyboardReturnSignal().subscribeNext({
                $0.resignFirstResponder()
                if (value != self.textFields.last) {
                    let helpIndex = index + 1
                    self.textFields[helpIndex]!.becomeFirstResponder()
                }
            })
        }
    }
}
