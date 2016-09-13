//
//  ShopsManager.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import ReactiveCocoa

class ShopsManager {
    
    static let sharedInstance = ShopsManager()
    
    var ref: FIRDatabaseReference
    
    init() {
        self.ref = FIRDatabase.database().reference()
    }
    
    func getShops(index index: Int, count: Int) -> SignalProducer <Array<ShopModel>, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Shops).observeEventType(FIRDataEventType.Value,
                withBlock: { (snapshot) in
                var postsViewModels = [ShopModel]()
                
                for list in snapshot.children {
                    let shop = ShopModel.init(snapshot: list as! FIRDataSnapshot)
                    postsViewModels.append(shop)
                }
                sink.sendNext(postsViewModels)
//                sink.sendCompleted()
            })
        }
    }
    
    func getShopsByName(name: String) -> SignalProducer <Array<ShopModel>, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Shops)
                .queryOrderedByChild(Constants.Shop.Name)
                .queryStartingAtValue(name).observeEventType(FIRDataEventType.Value,
                    withBlock: { (snapshot) in
                        var postsViewModels = [ShopModel]()
                        
                        for list in snapshot.children {
                            let shop = ShopModel.init(snapshot: list as! FIRDataSnapshot)
                            postsViewModels.append(shop)
                        }
                        sink.sendNext(postsViewModels)
                        sink.sendCompleted()
                })
        }
    }
    
    func createNewShopName(name: String, lastVisitDate: NSDate, lat: Float, lon: Float, planFrequency: Int, completionHandler: (isSuccess: Bool) ->()) {
        let newShop : [String : AnyObject] = [Constants.Shop.Name  : name,
                                              Constants.Shop.LastVisitDate : Converter.sringFromDate(lastVisitDate),
                                              Constants.Shop.Coordinate : ["lat": NSNumber(float: lat), "lon": NSNumber(float: lon)],
                                              Constants.Shop.PlanFrequency: NSNumber(integer: planFrequency)]

        self.ref.child(Constants.Shops).childByAutoId().setValue(newShop) { (error, reference) in
            completionHandler(isSuccess: error == nil)
        } 
    }
    
    func insertOrderToShopId(shopId: String, newOrderValue: Dictionary<String, NSNumber>) -> SignalProducer <Bool, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Shops).child(shopId).child(Constants.Shop.Orders).childByAutoId()
                .setValue(newOrderValue, withCompletionBlock: { (error, databaseRef) in
                    if  let error = error {
                        sink.sendFailed(error)
                    } else {
                        sink.sendNext(true)
                        sink.sendCompleted()
                    }
                })
        }
    }
    
}