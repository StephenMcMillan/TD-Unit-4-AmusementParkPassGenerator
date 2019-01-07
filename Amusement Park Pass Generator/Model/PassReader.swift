//
//  PassReader.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 07/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

/// Models a pass reader machine that could be located at any location around the park. Eg: At food area, ride queue etc..
class PassReader {
    static func swipe(_ pass: PermissionsReadable, forAccessTo secureArea: AccessArea) -> Bool {
        
        // Switch on the secure area that the pass wants access to.
        
        var accessStatus: Bool
        
        switch secureArea {
            
        case .parkArea(let area):
            accessStatus = pass.areaPermissions.contains(area)
        case .ride(let rideAccess):
            accessStatus = pass.ridePermissions.contains(rideAccess)
        }
        
        print("Access \(accessStatus ? "Granted" : "Denied")")
        return accessStatus
        
    }
}

class KioskCashRegister {
    // Kiosk cash register functions would be here.
    
    // During checkout the entrant can swipe to get x amount of discount off their purchase.
    static func swipe(_ pass: PermissionsReadable, forPurchaseOf purchase: PurchaseType) -> Percentage {
        
        for discount in pass.discountsAvailable {
            if case discount.appliesTo = purchase {
                return discount.amount
            }
        }
        
        return 0
    }
}
