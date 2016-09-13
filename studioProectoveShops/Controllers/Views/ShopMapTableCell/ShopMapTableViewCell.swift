//
//  ShopMapTableViewCell.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 9/13/16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class ShopMapTableViewCell: UITableViewCell {

    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var lastVisitDateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func fillByModel(model: ShopModel, distance: Float) {
        shopNameLabel.text = model.name
        frequencyLabel.text = String(model.planFrequency)
        lastVisitDateLabel.text = Converter.prettySringFromDate(model.lastVisitDate)
        distanceLabel.text = String(distance)
    }
    
    @IBAction func locationButtonAction(sender: AnyObject) {
        
        print("locationButtonAction")
        
    }
}
