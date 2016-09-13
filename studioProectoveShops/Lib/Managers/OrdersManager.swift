//
//  OrdersManager.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import ReactiveCocoa

class OrdersManager {
    
    static let sharedInstance = OrdersManager()
    
    var ref: FIRDatabaseReference
    
    init() {
        self.ref = FIRDatabase.database().reference()
    }
    
    func getOrders(index index: Int, count: Int) -> SignalProducer <Array<OrderModel>, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Orders).observeEventType(FIRDataEventType.Value,
                withBlock: { (snapshot) in
                    var ordersViewModels = [OrderModel]()
                    
                    for list in snapshot.children {
                        let order = OrderModel.init(snapshot: list as! FIRDataSnapshot)
                        ordersViewModels.append(order)
                    }
                    sink.sendNext(ordersViewModels)
                    //                sink.sendCompleted()
            })
        }
    }
    
    func createNewOrderShopIdentifier(shopModel: ShopModel, deliveryDate: NSDate, createDate: NSDate, totalPrice: Float, productArray: Dictionary<String, NSNumber>, completionHandler: (isSuccess: Bool) ->()) {
        let newOrder : [String : AnyObject] = [Constants.Order.ShopModel : shopModel.dictionaryPresentationForOrder(),
                                              Constants.Order.DeliveryDate : Converter.sringFromDate(deliveryDate),
                                              Constants.Order.CreateDate : Converter.sringFromDate(createDate),
                                              Constants.Order.TotalPrice : NSNumber(float: totalPrice),
                                              Constants.Order.OrderElementArray : productArray]
        
        self.ref.child(Constants.Orders).childByAutoId().setValue(newOrder) { (error, reference) in
            completionHandler(isSuccess: error == nil)
        } 
    }
}
