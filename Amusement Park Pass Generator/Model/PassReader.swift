//
//  PassReader.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 07/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// How to stop a pass being swiped more than 2 times... hmmm

/// Models a pass reader machine that could be located at any location around the park. Eg: At food area, ride queue etc..

// TODO: Create a PassReader error type so that swipe(pass: ParkPass... etc) can throw a passTimedOut error instead of a print statement.

class PassReader {
    
    static func swipe(pass: ParkPass, forAccessTo secureArea: AccessArea) -> Bool? {
        
        guard passIsUsable(pass) else {
            print("Please wait 5 seconds after swiping your pass before swiping again. Thank You.")
            return nil
        }
        
        alertIfBirthday(entrant: pass.holder)
        
        var accessStatus: Bool
        
        // Switch on the secure area that the pass wants access to.
        switch secureArea {
            
        case .parkArea(let area):
            accessStatus = pass.areaPermissions.contains(area)
        case .ride(let rideAccess):
            accessStatus = pass.ridePermissions.contains(rideAccess)
        }
        
        print("Access \(accessStatus ? "Granted" : "Denied")")
        
        pass.lastSwipe = Date()
        return accessStatus
        
    }
}

class KioskCashRegister {
    
    // During checkout the entrant can swipe to get x amount of discount off their purchase.
    static func swipe(pass: ParkPass, forPurchaseOf purchase: PurchaseType) -> Percentage? {
        
        guard passIsUsable(pass) else {
            print("Please wait 5 seconds after swiping your pass before swiping again. Thank You.")
            return nil
        }
        
        alertIfBirthday(entrant: pass.holder)
        
        for discount in pass.discountsAvailable {
            if case discount.appliesTo = purchase {
            
                print("Entrant is entitled to \(discount.amount)% off \(discount.appliesTo) purchases. :)")
                return discount.amount
            }
        }
        
        print("Entrant is not entitled to discounts of any kind. :(")
        return 0
    }
}

// Timer Helper
fileprivate func passIsUsable(_ pass: ParkPass?) -> Bool {
    
    guard let lastSwipeDate = pass?.lastSwipe else {
        pass?.lastSwipe = Date()
        return true
    }
    
    guard lastSwipeDate.addingTimeInterval(5) <= Date() else {
        pass?.lastSwipe = Date()
        return false
    }
    
    return true
}

// Birthday Helper
fileprivate func alertIfBirthday(entrant: Entrant?) {
    if let entrantWithBirthday = entrant as? AgeIdentifiable {
        if entrantWithBirthday.isBirthday {
            print("Happy Birthday from all of us here at the Park!")
        }
    }
}
