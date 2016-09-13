//
//  Constants.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//



struct Constants {
    static let Shops = "shops"
    static let Orders = "orders"
    static let Products = "products"
    
    struct Shop {
        static let Name = "name"
        static let Identifier = "anyShopIdentifier" // check way for copy in Firebase
        static let Coordinate = "coordinate"
        static let LastVisitDate = "lastVisitDate"
        static let Orders = "orders"
        static let PlanFrequency = "planFrequency"
    }
    
    struct Order {
        static let Identifier = "identifier"
        static let ShopModel = "shopModel"
        static let DeliveryDate = "deliveryDate"
        static let CreateDate = "createDate"
        static let OrderElementArray = "orderElementArray"
        static let TotalPrice = "totalPrice"
    }
    
    struct Product {
        static let Name = "name"
        static let Identifier = "identifier"
        static let Price = "price"
        static let Description = "description"
        static let InStorage = "inStorage"
    }
    
    struct Cell {
        static let cellIdentifier = "PostCell"
    }
}
