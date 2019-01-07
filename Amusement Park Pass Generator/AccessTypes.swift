//
//  AccessTypes.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 06/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

protocol PermissionsReadable {
    var areaPermissions: [AreaAccess] { get }
    var ridePermissions: [RideAccess] { get }
    var discountsAvailable: [DiscountType] { get }
}

/// Areas around the park that require authorised access.
enum AreaAccess {
    case amusement
    case kitchen
    case rideControl
    case maintenance
    case office
}

/// Types of Ride Access
enum RideAccess {
    case all
    case priorityQueueing // Allows entrant to skip all ride lines.
}

/// Types of Discount that Entrants can Receive
typealias Percentage = Int

enum DiscountType {
    case food(amount: Percentage)
    case merchandise(amount: Percentage)
}
