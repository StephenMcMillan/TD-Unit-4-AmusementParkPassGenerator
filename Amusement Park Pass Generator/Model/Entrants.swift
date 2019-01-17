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
    
    case contractor(workingOn: ContractorProject)
    case vendor(from: AuthorisedVendorCompany)
    
    enum Guest: CaseIterable {
        case regular
        case vip
        case child
        case seasonPassHolder
        case senior
    }
    
    enum Employee: CaseIterable {
        case foodServices
        case rideServices
        case maintenance
    }
    
    enum Manager: CaseIterable {
        case parkManager
    }
    
    enum ContractorProject: CaseIterable {
        case p1001
        case p1002
        case p1003
        case p2001
        case p2002
    }
    
    enum AuthorisedVendorCompany: CaseIterable {
        case Acme
        case Orkin
        case Fedex
        case NWElectrical
    }
    
    var areaPermissions: [AccessArea.Area] {
        switch self {
        case .guest:
            return [.amusement]
            
        case .employee(.foodServices):
            return [.amusement, .kitchen]
            
        case .employee(.rideServices):
            return [.amusement, .rideControl]
        
        case .employee(.maintenance):
            return [.amusement, .kitchen, .rideControl, .maintenance]
        
        // Area Access For Contractors
        case .contractor(workingOn: .p1001):
            return [.amusement, .rideControl]
            
        case .contractor(workingOn: .p1002):
            return [.amusement, .rideControl, .maintenance]
            
        case .contractor(workingOn: .p2001):
            return [.office]
            
        case .contractor(workingOn: .p2002):
            return [.kitchen, .maintenance]
            
        // Area Access For Vendors
        case .vendor(from: .Acme):
            return [.kitchen]
            
        case .vendor(from: .Orkin):
            return [.amusement, .rideControl, .kitchen]
            
        case .vendor(from: .Fedex):
            return [.maintenance, .office]
            
        // ** CASE FOR ACCESS TO ALL AREAS ** (Highest Level of Clearance)
        case .manager, .contractor(workingOn: .p1003), .vendor(from: .NWElectrical):
            return [.amusement, .kitchen, .rideControl, .maintenance, .office]
        }
    }
    
    var ridePermissions: [AccessArea.Ride] {
        switch self {
        case .guest(.regular), .guest(.child):
            return [.all]
            
        case .guest(.vip), .guest(.senior), .guest(.seasonPassHolder):
            return [.all, .priorityQueueing]

        case .employee, .manager:
            return [.all]
            
        case .vendor, .contractor:
            return []
        }
    }
    
    var discountsAvailable: [Discount] {
        switch self {
        case .guest(.regular), .guest(.child), .contractor, .vendor:
            return []
            
        case .guest(.vip), .guest(.seasonPassHolder):
            return [Discount(appliesTo: .food, amount: 10), Discount(appliesTo: .merchandise, amount: 20)]
            
        case .guest(.senior):
            return [Discount(appliesTo: .food, amount: 10), Discount(appliesTo: .merchandise, amount: 10)]
        
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
    var pass: ParkPass { get set }
}

// MARK: - Guests
class Guest: Entrant {
    var pass: ParkPass
    
    init(type: EntrantType = EntrantType.guest(.regular)) {
        self.pass = ParkPass(areaPermissions: type.areaPermissions,
                             ridePermissions: type.ridePermissions,
                             discountsAvailable: type.discountsAvailable)
        
        pass.holder = self
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
        
        guard ChildGuest.isChild(dateOfBirth: dob) else { throw InformationError.ageRequirementNotMet }
        
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
        
            pass.holder = self
        }
}
