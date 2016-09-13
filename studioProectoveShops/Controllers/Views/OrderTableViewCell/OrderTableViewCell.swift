//
//  OrderTableViewCell.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderIdentifierLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func fillByModel(model: OrderModel) {
        orderIdentifierLabel.text = model.identifier
        shopNameLabel.text = model.shopModel.name
        totalPriceLabel.text = String(Float(model.totalPrice ?? 0.0))
        deliveryDateLabel.text = Converter.prettySringFromDate(model.deliveryDate)
    }
}
