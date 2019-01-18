//
//  FormTextField.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 16/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

@IBDesignable
class FormTextField: UITextField {

    let padding = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return  bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func setupView() {
        layer.cornerRadius = 4
        layer.masksToBounds = false
        layer.borderWidth = 1.0
    }
    
    
    // MARK: - Highlighting Helper
    var isRequired: Bool {
        get {
            return isEnabled
        }
        
        set {
            if newValue {
                backgroundColor = .white
                isEnabled = newValue
            } else {
                backgroundColor = .clear
                isEnabled = newValue
            }
        }
    }
}
