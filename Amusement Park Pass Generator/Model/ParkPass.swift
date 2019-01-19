//
//  ParkPass.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 06/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// A common laguage between a pass card and a pass reader.

class ParkPass: PermissionsReadable {
    
    weak var holder: Person? = nil
    var lastSwipe: Date? = nil
    
    var areaPermissions: [AccessArea.Area]
    var ridePermissions: [AccessArea.Ride]
    var discountsAvailable: [Discount]

    init (areaPermissions: [AccessArea.Area], ridePermissions: [AccessArea.Ride], discountsAvailable: [Discount]) {
        self.areaPermissions = areaPermissions
        self.ridePermissions = ridePermissions
        self.discountsAvailable = discountsAvailable
    }
    
    convenience init(holder: EntrantType) {
        self.init(areaPermissions: holder.areaPermissions, ridePermissions: holder.ridePermissions, discountsAvailable: holder.discountsAvailable)
    }
}

