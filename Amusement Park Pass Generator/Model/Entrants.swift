//
//  Entrants.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 06/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// MARK: - Types of Entrants

enum EntrantType: PermissionsReadable {
    
    case guest(Guest)
    case employee(Employee)
    case manager(Manager)
    
    enum Guest: CaseIterable {
        case regular
        case vip
        case child
    }
    
    enum Employee: CaseIterable {
        case foodServices
        case rideServices
        case maintenance
    }
    
    enum Manager: CaseIterable {
        case parkManager
    }
    
    var areaPermissions: [AccessArea.Area] {
        switch self {
        case .guest:
            return [.amusement]
            
        case .employee(.foodServices):
            return [.amusement, .kitchen]
            
        case .employee(.rideServices):
            return [.amusement, .rideControl]
            
        case .employee(.maintenance), .manager:
            return [.amusement, .kitchen, .rideControl, .maintenance, .office]
        }
    }
    
    var ridePermissions: [AccessArea.Ride] {
        switch self {
        case .guest(.regular), .guest(.child):
            return [.all]
            
        case .guest(.vip):
            return [.all, .priorityQueueing]

        case .employee, .manager:
            return [.all]
        }
    }
    
    var discountsAvailable: [Discount] {
        switch self {
        case .guest(.regular), .guest(.child):
            return []
            
        case .guest(.vip):
            return [Discount(appliesTo: .food, amount: 10), Discount(appliesTo: .merchandise, amount: 20)]
        
        case .employee:
            return [Discount(appliesTo: .food, amount: 15), Discount(appliesTo: .merchandise, amount: 25)]
        
        case .manager:
            return [Discount(appliesTo: .food, amount: 25), Discount(appliesTo: .merchandise, amount: 25)]
        }
    }
}

// MARK: - Entrant
/// All Entrants to the park must have a valid access pass.
protocol Entrant: class {
    var pass: ParkPass { get }

}

// MARK: - Guests
class Guest: Entrant {
    let pass: ParkPass
    
    init(type: EntrantType = EntrantType.guest(.regular)) {
        self.pass = ParkPass(areaPermissions: type.areaPermissions,
                             ridePermissions: type.ridePermissions,
                             discountsAvailable: type.discountsAvailable)
    }
}

class VIPGuest: Guest {
    init() {
        super.init(type: .guest(.vip))
    }
}

class ChildGuest: Guest, AgeIdentifiable {
    
    var dateOfBirth: Date
    
    init(dateOfBirth: Date?) throws {
        
        // Children must
        guard let dob = dateOfBirth else { throw InformationError.missingBirthday }
        self.dateOfBirth = dob
        
        guard ChildGuest.isChild(dob: dob) else { throw InformationError.ageRequirementNotMet }
        
        super.init(type: .guest(.child))
    }
}

// MARK: - Employees

protocol Employable: Nameable, Mailable {}

// Hourly Employees and Managers have the same style of set-up so they're differentiated using the type property.
class Employee: Entrant, Employable {
    
    var type: EntrantType
    var pass: ParkPass
    
    var firstName: String
    var lastName: String
    var address: Address
    
    init(type: EntrantType, firstName: String?, lastName: String?, streetAddress: String?, city: String?, state: String?, zipCode: String?) throws {
    
            guard let firstName = firstName else { throw InformationError.missingFirstName }
            guard let lastName = lastName else { throw InformationError.missingLastName }
    
            guard let streetAddress = streetAddress else { throw InformationError.missingStreetAddress }
            guard let city = city else { throw InformationError.missingCity }
            guard let state = state else { throw InformationError.missingState }
            guard let zipCode = zipCode else { throw InformationError.missingZipCode }
    
            self.firstName = firstName
            self.lastName = lastName
            self.address = Address(streetAddress: streetAddress, city: city, state: state, zipCode: zipCode)
        
            self.type = type
            pass = ParkPass(areaPermissions: type.areaPermissions,
                            ridePermissions: type.ridePermissions,
                            discountsAvailable: type.discountsAvailable)
        }
}
