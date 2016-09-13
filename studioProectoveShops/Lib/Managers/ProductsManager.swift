//
//  ProductsManager.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import ReactiveCocoa

class ProductsManager {
    
    static let sharedInstance = ProductsManager()
    
    var ref: FIRDatabaseReference
    
    init() {
        self.ref = FIRDatabase.database().reference()
    }
    
    func getProducts(index index: Int, count: Int) -> SignalProducer <Array<ProductModel>, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Products).observeEventType(FIRDataEventType.Value,
                withBlock: { (snapshot) in
                    var postsViewModels = [ProductModel]()
                    
                    for list in snapshot.children {
                        let product = ProductModel.init(snapshot: list as! FIRDataSnapshot)
                        postsViewModels.append(product)
                    }
                    sink.sendNext(postsViewModels)
                    //                sink.sendCompleted()
            })
        }
    }
    
    func getProductsByName(name: String) -> SignalProducer <Array<ProductModel>, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Products)
                .queryOrderedByChild(Constants.Product.Name)
                .queryStartingAtValue(name).observeEventType(FIRDataEventType.Value,
                    withBlock: { (snapshot) in
                        var postsViewModels = [ProductModel]()
                        
                        for list in snapshot.children {
                            let product = ProductModel.init(snapshot: list as! FIRDataSnapshot)
                            postsViewModels.append(product)
                        }
                        sink.sendNext(postsViewModels)
                        sink.sendCompleted()
                })
        }
    }
    
    func changeInStorageCountByProductId(productId: String, newValue: Int) -> SignalProducer <Bool, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            let updatedDict = [Constants.Product.InStorage : NSNumber(integer: newValue)]
            
            self.ref.child(Constants.Products).child(productId)
                .updateChildValues(updatedDict, withCompletionBlock: { (error, baseReference) in
                    if let error = error {
                        sink.sendFailed(error)
                    } else {
                        sink.sendNext(true)
                        sink.sendCompleted()
                    }
                })
        }
    }
    
}
