//
//  ShopsListViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 10.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class ShopsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var shopsArray: [ShopModel]?
    
    
    static func controllerFromStoryboard() -> ShopsListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(String(ShopsListViewController)) as! ShopsListViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShopsManager.sharedInstance.getShops(index: 0, count: 20)
            .on(failed: { (error) in
                print("Get Error from firebase = \(error)")
                }) { (shopModels) in
                    self.shopsArray = shopModels
                    self.tableView.reloadData()
        }.start()
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }

//    MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopsArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let simpleTableIdentifier = "ShopTableViewCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(simpleTableIdentifier) as? ShopTableViewCell
        if (cell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed(simpleTableIdentifier, owner: self, options: nil)
            cell = nib.first as? ShopTableViewCell
        }
        
        cell?.fillByModel(shopsArray![indexPath.row])
        
        return cell!
    }
    
//    MARK: - UITableViewDelegate  
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        let showShopController = ShopLocationViewController.controllerFromStoryboard()
        showShopController.shopModel = shopsArray![indexPath.row]
        
        navigationController?.pushViewController(showShopController, animated: true)
    }
    
//    MARK: - Actions
    
    @IBAction func backButtonAction(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func addShopButtonAction(sender: AnyObject) {
        navigationController?.pushViewController(CreateShopViewController.controllerFromStoryboard(), animated: true)
    }
}
