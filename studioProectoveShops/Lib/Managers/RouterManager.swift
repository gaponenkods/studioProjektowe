//
//  RouterManager.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import UIKit

class RouterManager {
    let navigationController : UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: - Prepare functions
    
    func createControllerFromStoryboardName(storyboardName: String, identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(identifier)
        return controller
    }
    
    func presentController(viewController: UIViewController) {
        let navController = self.navigationController
        if navController.topViewController == navController.viewControllers[0] {
            navController.pushViewController(viewController, animated: true)
            return
        }
        let previousController = navController.viewControllers[navController.viewControllers.count-2]
        
        if previousController.classForCoder == viewController.classForCoder {
            navController.popViewControllerAnimated(true)
        } else {
            navController.pushViewController(viewController, animated: true)
//            self.navigationController.viewControllers[0] = viewController
//            pushViewController(viewController, animated: true)
        }
    }
    
    //MARK: - Show Controllers
    
    func showSignUpController() {
        self.presentController(SignUpViewController())
    }
    
    func showSignInController() {
        self.presentController(SignInViewController())
    }
    
    func showBlogTabBarController() {
        self.presentController(self.createControllerFromStoryboardName("Main", identifier: String(ViewController)))
    }
    
    //MARK: - Show Alerts
    
    func displayAlertController(alertController: UIAlertController) {
        navigationController.topViewController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func displayAlertTitle(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        displayAlertController(alertController)
    }

}