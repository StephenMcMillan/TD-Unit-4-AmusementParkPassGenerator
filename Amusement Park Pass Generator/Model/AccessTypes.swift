//
//  AccessTypes.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 06/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

protocol PermissionsReadable {
    var areaPermissions: [AccessArea.Area] { get }
    var ridePermissions: [AccessArea.Ride] { get }
    var discountsAvailable: [Discount] { get }
}

/// Areas around the park that require authorised access.
enum AccessArea {
    case parkArea(Area)
    case ride(Ride)
    
    enum Area {
        case amusement
        case kitchen
        case rideControl
        case maintenance
        case office
    }
    
    /// Types of Ride Access
    enum Ride {
        case all
        case priorityQueueing // Allows entrant to skip all ride lines.
    }
}

// It makes more sense to keep discount privileges separate from areas that are accessible to entrants given that in a real world situation the system/pass reader for a cash register at a food or merchandise stall would have different logic to that of a pass reader on a door or gate at a ride.

/// Types of Discount that Entrants can Receive

enum PurchaseType {
    case food
    case merchandise
}
struct Discount {
    var appliesTo: PurchaseType
    var amount: Percentage
}

let foodDiscount = Discount(appliesTo: .food, amount: 25)
typealias Percentage = Int





