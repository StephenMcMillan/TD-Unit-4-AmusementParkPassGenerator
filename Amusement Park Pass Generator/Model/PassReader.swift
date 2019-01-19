//
//  PassReader.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 07/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

protocol Swipeable {
    static func swipe(_ pass: ParkPass, type: SwipeType) -> SwipeResult
}

extension Swipeable {
    
    static func swipe(_ pass: ParkPass, type: SwipeType) -> SwipeResult {
        
        defer {
            pass.lastSwipe = Date()
        }
        
        guard passIsUsable(pass) else {
            return .timedOut
        }
        
        switch type {
            
        case .secureArea(let accessArea):
            
            switch accessArea {
                
            case .parkArea(let area):
                return pass.areaPermissions.contains(area) ? .accessGranted : .accessDenied
            case .ride(let rideAccess):
                return pass.ridePermissions.contains(rideAccess) ? .accessGranted : .accessDenied
            }
            
        case .discount(let purchaseType):
            
            for discount in pass.discountsAvailable {
                if case discount.appliesTo = purchaseType {
                    return SwipeResult.discountAvailable(discount: discount)
                }
            }
            
            return .noDiscount
        }
    }
}

// This is an example of a physical object that may be at a ride entrance.
class PassReader: Swipeable {}

// This is an example of a physical cash register than may be a food or merch store in the park.
class KioskCashRegister: Swipeable {}

// Swipe Type
enum SwipeType {
    case secureArea(AccessArea)
    case discount(PurchaseType)
}

// Swipe Result
enum SwipeResult {
    case accessGranted
    case accessDenied
    case discountAvailable(discount: Discount)
    case noDiscount
    case timedOut
}

extension SwipeResult: Equatable {
    static func == (lhs: SwipeResult, rhs: SwipeResult) -> Bool {
        switch (lhs, rhs) {
            
        case (.accessGranted, .accessGranted), (.accessDenied, .accessDenied), (.noDiscount, .noDiscount), (.timedOut, .timedOut):
            return true
        case (discountAvailable(let discountLHS), discountAvailable(let discountRHS)):
            return discountRHS == discountLHS ? true : false
        default:
            return false
        }
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

// ** NOT NEEDED **
//// Birthday Helper
//fileprivate func alertIfBirthday(entrant: Person?) {
//    if let entrantWithBirthday = entrant as? AgeIdentifiable {
//        if entrantWithBirthday.isBirthday {
//            print("Happy Birthday from all of us here at the Park!")
//        }
//    }
//}
