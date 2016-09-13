//
//  ProductTableViewCell.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

typealias ProductStateChanged = (isSelected: Bool, selectedCount: Int) -> ()

class ProductTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var productIdentifierLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var inStorageDateLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var countGetTextField: UITextField!
    
    var productModel: ProductModel!
    
    var stateChangedBlock: ProductStateChanged?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done,
                                              target: self,
                                              action: #selector(self.finishEditing))
        
        keyboardDoneButtonView.items = [doneButton]
        countGetTextField.inputAccessoryView = keyboardDoneButtonView
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillByModel(model: ProductModel) {
        productModel = model
        productIdentifierLabel.text = model.identifier
        productNameLabel.text = model.name
        inStorageDateLabel.text = String(model.inStorage)
        countGetTextField.delegate = self
    }

//    MARK: - UITextFieldDelegate

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        finishEditing()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        finishEditing()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool  {
        var txtAfterUpdate = textField.text! as NSString
        txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
        let stringValue = String(txtAfterUpdate)
        return (Int(stringValue) != nil) || stringValue.characters.count == 0 ? true : false
    }
    
//    MARK: - Events
    
    func finishEditing() {
        if let stateChangedBlock = stateChangedBlock {
            stateChangedBlock(isSelected: checkBoxButton.selected, selectedCount: Int(countGetTextField.text ?? "0") ?? 0)
        }
        countGetTextField.resignFirstResponder()
    }
    
    func setSelectedCell(selected: Bool) -> () {
        checkBoxButton.selected = selected
        if let stateChangedBlock = stateChangedBlock {
            stateChangedBlock(isSelected: selected, selectedCount: Int(countGetTextField.text ?? "0") ?? 0)
        }
    }
    
//    MARK: - Actions
    
    @IBAction func checkBoxButtonAction(sender: UIButton) {
        setSelectedCell(!sender.selected)
        print("checkBoxButtonAction")
    }
    
}
