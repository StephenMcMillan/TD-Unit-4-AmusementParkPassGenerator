//
//  ParkPass.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 06/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// A common laguage between a pass card and a pass reader.

struct ParkPass: PermissionsReadable {
    var areaPermissions: [AccessArea.Area]
    var ridePermissions: [AccessArea.Ride]
    var discountsAvailable: [Discount]
}

