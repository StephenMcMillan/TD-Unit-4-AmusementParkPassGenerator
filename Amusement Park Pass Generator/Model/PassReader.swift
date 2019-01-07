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
    static func swipe(swipedBy entrant: Entrant, forAccessTo secureArea: AccessArea) -> Bool {
        
        // Switch on the secure area that the pass wants access to.
        
        var accessStatus: Bool
        
        alertIfBirthday(entrant: entrant)
        
        switch secureArea {
            
        case .parkArea(let area):
            accessStatus = entrant.pass.areaPermissions.contains(area)
        case .ride(let rideAccess):
            accessStatus = entrant.pass.ridePermissions.contains(rideAccess)
        }
        
        print("Access \(accessStatus ? "Granted" : "Denied")")
        return accessStatus
        
    }
}

class KioskCashRegister {
    // Kiosk cash register functions would be here.
    
    // During checkout the entrant can swipe to get x amount of discount off their purchase.
    static func swipe(swipedBy entrant: Entrant, forPurchaseOf purchase: PurchaseType) -> Percentage {
        
        alertIfBirthday(entrant: entrant)
        
        for discount in entrant.pass.discountsAvailable {
            if case discount.appliesTo = purchase {
            
                print("Entrant is entitled to \(discount.amount)% off \(discount.appliesTo) purchases. :)")
                return discount.amount
            }
        }
        
        print("Entrant is not entitled to discounts of any kind. :(")
        return 0
    }
}

func alertIfBirthday(entrant: Entrant) {
    if let entrantWithBirthday = entrant as? AgeIdentifiable {
        if entrantWithBirthday.isBirthday() {
            print("Happy Birthday from all of us here at the Park!")
        }
    }
}
