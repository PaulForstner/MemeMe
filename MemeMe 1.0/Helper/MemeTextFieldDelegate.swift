//
//  MemeTextFieldDelegate.swift
//  MemeMe 1.0
//
//  Created by Paul Forstner on 06.06.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

extension MemeMeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == Constants.standartTopText || textField.text == Constants.standartBottomText {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
