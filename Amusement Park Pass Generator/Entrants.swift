//
//  Entrants.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 06/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// MARK: - Types of Entrants
enum EntrantType {
    case guest
    case employee
    case manager
}

enum GuestType: PermissionsReadable {
    case regular
    case vip
    case child
    
    var areaPermissions: [AreaAccess] {
        return [.amusement]
    }
    
    var ridePermissions: [RideAccess] {
        switch self {
        case .regular, .child:
            return [.all]
        case .vip:
            return [.all, .priorityQueueing]
        }
    }
    
    var discountsAvailable: [DiscountType] {
        switch self {
        case .regular, .child:
            return []
        case .vip:
            return [.food(amount: 10), .merchandise(amount: 20)]
        }
    }
}

enum EmployeeType: PermissionsReadable {
    case foodServices
    case rideServices
    case maintenance
    
    var areaPermissions: [AreaAccess] {
        switch self {
        case .foodServices:
            return [.amusement, .kitchen]
        case .rideServices:
            return [.amusement, .rideControl]
        case .maintenance:
            return [.amusement, .kitchen, .rideControl, .maintenance, .office]
        }
    }
    
    var ridePermissions: [RideAccess] {
        return [.all]
    }
    
    var discountsAvailable: [DiscountType] {
        return [.food(amount: 15), .merchandise(amount: 25)]
    }
}

enum ManagerType: PermissionsReadable {
    case regular
    
    var areaPermissions: [AreaAccess] {
        return [.amusement, .kitchen, .rideControl, .maintenance, .office]
    }
    
    var ridePermissions: [RideAccess] {
        return [.all]
    }
    
    var discountsAvailable: [DiscountType] {
        return [.food(amount: 25), .merchandise(amount: 25)]
    }
}

// MARK: - Entrant
/// All Entrants to the park must have a valid access pass.
protocol Entrant {
    var pass: ParkPass { get }
}

// MARK: - Guests
class Guest: Entrant {
    let pass: ParkPass
    
    init(type: GuestType = .regular) {
        self.pass = ParkPass(areaPermissions: type.areaPermissions,
                             ridePermissions: type.ridePermissions,
                             discountsAvailable: type.discountsAvailable)
    }
}

class VIPGuest: Guest {
    init() {
        super.init(type: .vip)
    }
}

class ChildGuest: Guest, AgeIdentifiable {
    
    var dateOfBirth: Date
    
    init(dateOfBirth: Date) {
        self.dateOfBirth = dateOfBirth
        super.init(type: .child)
    }
}

// MARK: - Employees

class Employee: Entrant, Nameable, Mailable {
    
    var pass: ParkPass
    
    var firstName: String
    var lastName: String
    
    var address: Address
    
    // This is fileprivate so instances of this base class are not initialized.
    fileprivate init(type: EmployeeType, firstName: String, lastName: String, address: Address) {
    
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.pass = ParkPass(areaPermissions: type.areaPermissions,
                             ridePermissions: type.ridePermissions,
                             discountsAvailable: type.discountsAvailable)
    }
}

class FoodServicesEmployee: Employee {
    init(firstName: String, lastName: String, address: Address) {
        super.init(type: .foodServices, firstName: firstName, lastName: lastName, address: address)
    }
}

class RideServicesEmployee: Employee {
    init(firstName: String, lastName: String, address: Address) {
        super.init(type: .rideServices, firstName: firstName, lastName: lastName, address: address)
    }
}

class MaintenanceEmployee: Employee {
    init(firstName: String, lastName: String, address: Address) {
        super.init(type: .maintenance, firstName: firstName, lastName: lastName, address: address)
    }
}

// MARK: - Manager
class Manager: Entrant, Nameable, Mailable {
    var pass: ParkPass
    
    var firstName: String
    var lastName: String
    
    var address: Address
    
    init(firstName: String, lastName: String, address: Address ) {
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        
        self.pass = ParkPass(areaPermissions: [.amusement, .kitchen, .rideControl, .maintenance, .office],
                             ridePermissions: [.all],
                             discountsAvailable: [.food(amount: 25), .merchandise(amount: 25)])
    }
}




