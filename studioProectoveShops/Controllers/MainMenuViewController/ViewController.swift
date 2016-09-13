//
//  ViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = LocationManager.sharedInstance.locationManager
        print("location manager = \(locationManager)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.navigationController?.navigationItem.leftBarButtonItem = nil
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mapButtonAction(sender: AnyObject) {
        print("mapButtonAction")
        navigationController?.pushViewController(TaskTodayViewController.controllerFromStoryboard(), animated: true)
    }
    
    @IBAction func orderListButtonAction(sender: AnyObject) {
        print("orderListButtonAction")
        navigationController?.pushViewController(OrdersListViewController.controllerFromStoryboard(), animated: true)
    }
    
    @IBAction func shopsListButtonAction(sender: AnyObject) {
        print("shopsListButtonAction")
        navigationController?.pushViewController(ShopsListViewController.controllerFromStoryboard(), animated: true)
    }
}

