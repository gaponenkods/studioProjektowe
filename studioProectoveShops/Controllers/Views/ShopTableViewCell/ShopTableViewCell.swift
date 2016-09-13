//
//  ShopTableViewCell.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 10.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {

    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var lastVisitDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fillByModel(model: ShopModel) {
        shopNameLabel.text = model.name
        frequencyLabel.text = String(model.planFrequency)
        lastVisitDateLabel.text = Converter.prettySringFromDate(model.lastVisitDate)
    }
    
    @IBAction func locationButtonAction(sender: AnyObject) {
        
        print("locationButtonAction")
        
    }
}
