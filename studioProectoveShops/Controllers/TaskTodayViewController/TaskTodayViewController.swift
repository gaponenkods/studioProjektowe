//
//  TaskTodayViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 9/13/16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class TaskTodayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var selectedShop: ShopModel?
    var shopsArray: [ShopModel]?
    var distanceDictionary = [String: NSNumber]()
    
    static func controllerFromStoryboard() -> TaskTodayViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(String(TaskTodayViewController)) as! TaskTodayViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllShops()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //    MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopsArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let simpleTableIdentifier = "ShopMapTableViewCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(simpleTableIdentifier) as? ShopMapTableViewCell
        if (cell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed(simpleTableIdentifier, owner: self, options: nil)
            cell = nib.first as? ShopMapTableViewCell
        }
        let shop = shopsArray![indexPath.row]
        
        let distance = distanceDictionary[shop.identifier]?.floatValue
        cell?.fillByModel(shop, distance: distance!)
        
        if let selectedShop = selectedShop {
            if selectedShop.identifier == shopsArray![indexPath.row].identifier {
                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            }
        }
        
        return cell!
    }
    
    //    MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedShop = shopsArray![indexPath.row]
        let destShop = shopsArray![indexPath.row]
        let mapViewController = MapViewController.controllerFromStoryboard()
        if indexPath.row == 0 {
            if let curretnLocation = LocationManager.sharedInstance.currentLocation {
                mapViewController.sourceLocation = curretnLocation
            } else {
                router().displayAlertTitle("Sorry", message: "We can't get your curretn Location")
            }
        } else {
            let sourceShop = shopsArray![indexPath.row - 1]
            mapViewController.sourceLocation = CLLocation(latitude: Double((sourceShop.lat)), longitude: Double((sourceShop.lon)))
        }
        mapViewController.destinationLocation = CLLocation(latitude: Double((destShop.lat)), longitude: Double((destShop.lon)))
        
         navigationController?.pushViewController(mapViewController, animated: true)
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
    //    MARK: - Sort func
    
    func sortedShopsArrayByNearestLocation(shopsArray: [ShopModel]) -> [ShopModel] {
        
        var validShops = [ShopModel]()
        
        for shopModel in shopsArray {
            var lastVisitDay = Converter.dateFromDayString(Converter.daySringFromDate(shopModel.lastVisitDate))
            lastVisitDay = lastVisitDay?.dateByAddingTimeInterval(24 * 60 * 60 * Double(shopModel.planFrequency))
            if NSDate().dateByAddingTimeInterval(24 * 60 * 60 * 2).compare(lastVisitDay!) == NSComparisonResult.OrderedDescending {
                validShops.append(shopModel)
            }
        }
        
        func findNearestShopToLocation(sourceLocation: CLLocation) -> ShopModel? {
            guard validShops.count > 0 else {
                return nil
            }
            
            var nearestShop: ShopModel!
            var distance: CLLocationDistance? = nil
            
            for shop in validShops {
                let destLocation = CLLocation(latitude: Double(shop.lat), longitude: Double(shop.lon))
                if distance == nil {
                    distance = sourceLocation.distanceFromLocation(destLocation)
                }
                
                print("search distance \(sourceLocation.distanceFromLocation(destLocation))")
                
                if sourceLocation.distanceFromLocation(destLocation) <= distance! {
                    distance = sourceLocation.distanceFromLocation(destLocation)
                    nearestShop = shop
                }
            }
            
            print("distance between locations \(distance)\n\n")
            
            validShops.removeAtIndex(validShops.indexOf(nearestShop)!)
            distanceDictionary[nearestShop.identifier] = NSNumber(float: Float(distance!))
            return nearestShop
        }
        
        var sortedArray = [ShopModel]()
        
        for i in 0..<validShops.count {
            if i == 0 {
                if let curretnLocation = LocationManager.sharedInstance.locationManager.location {
                    let nearestShopModel = findNearestShopToLocation(curretnLocation)
                    if let nearestShopModel = nearestShopModel {
                        sortedArray.append(nearestShopModel)
                    } else {
                        break
                    }
                } else {
                    router().displayAlertTitle("Sorry", message: "We can't get your curretn Location")
                }
            } else {
                
                let curretnLocation = CLLocation(latitude: Double((sortedArray.last?.lat)!), longitude: Double((sortedArray.last?.lon)!))
                let nearestShopModel = findNearestShopToLocation(curretnLocation)
                if let nearestShopModel = nearestShopModel {
                    sortedArray.append(nearestShopModel)
                } else {
                    break
                }
            }
        }
        
        return sortedArray
    }
    
    //    MARK: - Actions
    
    @IBAction func backButtonAction(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
