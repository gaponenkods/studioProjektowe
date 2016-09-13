//
//  SelectShopViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

typealias SelectShopBlock = (shopModel: ShopModel) -> ()

class SelectShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedShop: ShopModel?
    var selectBlock: SelectShopBlock?
    var shopsArray: [ShopModel]?
    
    static func controllerFromStoryboard() -> SelectShopViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(String(SelectShopViewController)) as! SelectShopViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllShops()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }

//    MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        findShop()
    }
    
    func searchBarResultsListButtonClicked(searchBar: UISearchBar) {
        findShop()
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
        
        if let selectedShop = selectedShop {
            if selectedShop.identifier == shopsArray![indexPath.row].identifier {
                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            }
        }
        
        return cell!
    }
    
//    MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedShop = shopsArray![indexPath.row]
    }
    
//    MARK: - Get Shop Functions
    
    func getAllShops() {
        ShopsManager.sharedInstance.getShops(index: 0, count: 20)
            .on(failed: { (error) in
                print("(SelectShopViewController) Get Error from firebase = \(error)")
            }) { (shopModels) in
                self.shopsArray = self.sortedShopsArrayByNearestLocation(shopModels)
                self.tableView.reloadData()
            }.start()
    }
    
    func findShop() {
        guard let searchShopName = searchBar!.text else {
            return
        }
        
        searchBar.resignFirstResponder()
        ShopsManager.sharedInstance.getShopsByName(searchShopName)
            .on(failed: { (error) in
                print("(SelectShopViewController) Get Error from firebase = \(error)")
            }) { (shopModels) in
                self.shopsArray = self.sortedShopsArrayByNearestLocation(shopModels)
                self.tableView.reloadData()
            }.start()
    }
    
//    MARK: - Sort func
    
    func sortedShopsArrayByNearestLocation(shopsArray: [ShopModel]) -> [ShopModel] {
        
        if let currentLocation = LocationManager.sharedInstance.currentLocation {
            
            let kShopModel = "shopModel"
            let kDistance = "distance"
            
            var presentingShopsArray: Array<Dictionary<String, AnyObject>> = Array()
            
            for (_, shopModel) in shopsArray.enumerate() {
                let shopLocation = CLLocation(latitude: Double(shopModel.lat), longitude: Double(shopModel.lon))
                let distance = currentLocation.distanceFromLocation(shopLocation)
                let dict = [kShopModel: shopModel, kDistance: NSNumber(float: Float(distance))]
                presentingShopsArray.append(dict)
            }

            presentingShopsArray.sortInPlace({ (dictionaryFirst, dictionaryNext) -> Bool in
                let distanceFirst = (dictionaryFirst[kDistance] as? NSNumber)?.floatValue
                let distanceNext = (dictionaryNext[kDistance] as? NSNumber)?.floatValue
                return distanceFirst < distanceNext
            })
            
            var sortedArray = [ShopModel]()
            
            for dictionary in presentingShopsArray {
                let shopModel = dictionary[kShopModel] as! ShopModel
                sortedArray.append(shopModel)
            }
            
            return sortedArray
        } else {
            
            return shopsArray
        }
    }
    
//    MARK: - Actions
    
    @IBAction func backButtonAction(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func selectShopAction(sender: AnyObject) {
        if let selectedShop = selectedShop {
            if let selectBlock = selectBlock {
                selectBlock(shopModel: selectedShop)
            }
            navigationController?.popViewControllerAnimated(true)
        } else {
            router().displayAlertTitle("Sorry", message: "Please, select shop from list")
        }
    }
}
