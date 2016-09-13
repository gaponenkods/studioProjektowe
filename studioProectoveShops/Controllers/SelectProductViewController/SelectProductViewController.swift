//
//  SelectProductViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

typealias SelectProductsBlock = (productModels: [String: NSNumber]) -> ()

class SelectProductViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var currentOrder = [String: NSNumber]()
    var previousBigOrder: Dictionary<String, NSNumber>?
    var productsList: Array<ProductModel>?
    
    var selectBlock: SelectProductsBlock?
    
    var shopModel: ShopModel! {
        didSet {
            fetchPreviousBigOrder()
        }
    }
    
    static func controllerFromStoryboard() -> SelectProductViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(String(SelectProductViewController)) as! SelectProductViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAllProducts()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //    MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        findProduct()
    }
    
    func searchBarResultsListButtonClicked(searchBar: UISearchBar) {
        findProduct()
    }
    
    //    MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsList?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let simpleTableIdentifier = "ProductTableViewCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(simpleTableIdentifier) as? ProductTableViewCell
        if (cell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed(simpleTableIdentifier, owner: self, options: nil)
            cell = nib.first as? ProductTableViewCell
        }
        
        let product = productsList![indexPath.row]
        cell?.fillByModel(product)
        
        if let countGet = (currentOrder[product.identifier])?.integerValue {
            cell?.countGetTextField.text = String(countGet)
            cell?.setSelectedCell(true)
        } else if let previousBigOrder = previousBigOrder {
            if let countGet = (previousBigOrder[product.identifier])?.integerValue {
                cell?.countGetTextField.text = String(countGet)
                cell?.setSelectedCell(false)
            } else {
                cell?.countGetTextField.text = String(0)
                cell?.setSelectedCell(false)
            }
        } else {
            cell?.countGetTextField.text = String(0)
            cell?.setSelectedCell(false)
        }
        
        cell!.stateChangedBlock = {(isSelected, selectedCount) -> () in
            if isSelected {
                if selectedCount > 0 {
                    self.currentOrder[(cell?.productModel.identifier)!] = NSNumber(integer: selectedCount)
                } else {
                    self.currentOrder.removeValueForKey((cell?.productModel.identifier)!)
                }
            } else {
                self.currentOrder.removeValueForKey((cell?.productModel.identifier)!)
            }
        }
            
        return cell!
    }
    
    //    MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //    MARK: - Get Shop Functions
    
    func getAllProducts() {
        ProductsManager.sharedInstance.getProducts(index: 0, count: 20)
            .on(failed: { (error) in
                print("(SelectProductViewController) Get Error from firebase = \(error)")
            }) { (productModels) in
                self.productsList = self.sortedProductsArrayByLatestOrder(productModels)
                self.tableView.reloadData()
            }.start()
    }
    
    func findProduct() {
        guard let searchProductName = searchBar!.text else {
            return
        }
        
        searchBar.resignFirstResponder()
        
        ProductsManager.sharedInstance.getProductsByName(searchProductName)
            .on(failed: { (error) in
                print("(SelectProductViewController) Get Error from firebase = \(error)")
            }) { (productModels) in
                self.productsList = self.sortedProductsArrayByLatestOrder(productModels)
                self.tableView.reloadData()
            }.start()
    }
    
    //    MARK: - Sort func
    
    func fetchPreviousBigOrder() {
        guard let helpShopModel = shopModel where helpShopModel.orderArray != nil else {
            return
        }
        
        var largeSumOfOrders = [String: NSNumber]()
        
        for (_, orderDict) in helpShopModel.orderArray! {
//            for (keyOrder, orderDict) in dictionary {
        
                for (keyProductID, productCount) in orderDict {
                    if let comparingValue = largeSumOfOrders[keyProductID] {
                        largeSumOfOrders[keyProductID] = comparingValue.integerValue < productCount.integerValue ? productCount : comparingValue
                    } else {
                        largeSumOfOrders[keyProductID] = productCount
                    }
                }
//            }
        }
        
        if largeSumOfOrders.count > 0 {
            previousBigOrder = largeSumOfOrders
        }
    }
    
    func sortedProductsArrayByLatestOrder(productsArray: [ProductModel]) -> [ProductModel] {
        
        if let previousBigOrder = previousBigOrder{
            var arrayWithLastOrdersModels = [ProductModel]()
            var arrayWithoutOrders = [ProductModel]()
            
            for productModel in productsArray {
                if previousBigOrder[productModel.identifier] != nil {
                    arrayWithLastOrdersModels.append(productModel)
                } else {
                    arrayWithoutOrders.append(productModel)
                }
            }
            
            arrayWithLastOrdersModels.appendContentsOf(arrayWithoutOrders)
            
            return arrayWithLastOrdersModels
            
        } else {
           return productsArray
        }
    }
    
    //    MARK: - Actions
    
    @IBAction func backButtonAction(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func selectProductsAction(sender: AnyObject) {
        if currentOrder.count > 0 {
            if let selectBlock = selectBlock {
                selectBlock(productModels: currentOrder)
            }
            navigationController?.popViewControllerAnimated(true)
        } else {
            router().displayAlertTitle("Sorry", message: "Please, select product from list")
        }
    }
    
}
