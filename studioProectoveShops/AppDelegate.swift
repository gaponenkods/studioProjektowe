//
//  AppDelegate.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: RouterManager?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        FIRApp.configure()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        
        let blogTabBarController = storyboard.instantiateViewControllerWithIdentifier(String(ViewController))
        
//        try! FIRAuth.auth()!.signOut()
        
        let rootController = FIRAuth.auth()?.currentUser == nil ? SignInViewController() : blogTabBarController
        let navController = UINavigationController.init(rootViewController: rootController)
        
        self.router = RouterManager(navigationController: navController)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

