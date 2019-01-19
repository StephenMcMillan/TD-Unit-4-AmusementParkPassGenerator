//
//  Helpers.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 17/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

/// Creates and returns a button with button styling applied for the sub-header menu.

extension UIButton {
    static func createSubEntrantButton(withTitle title: String) -> UIButton {
        let button = UIButton.init(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        return button
    }
}

extension Date {
    static func create(from stringRepresentation: String) -> Date? {
        let dateFormtatter = DateFormatter()
        dateFormtatter.dateFormat = "dd - MM - yyyy"
        return dateFormtatter.date(from: stringRepresentation)
    }
}

