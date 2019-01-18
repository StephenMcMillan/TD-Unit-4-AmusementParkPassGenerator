//
//  Entrants.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 06/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// MARK: - Entrants / People
protocol Person: class {
    var type: EntrantType { get set }
    var pass: ParkPass { get set }
}

// Guests
class Guest: Person {
    
    var type: EntrantType
    var pass: ParkPass
    
    init(type: EntrantType.Guest) {
        self.type = EntrantType.guest(type)
        self.pass = ParkPass(holder: self.type)
        pass.holder = self
    }
}

class ChildGuest: Guest, AgeIdentifiable {    
    
    var dateOfBirth: Date?
    
    init() {
        super.init(type: .child)
    }
}

class SeniorGuest: Guest, Nameable, AgeIdentifiable {
    
    var firstName: String?
    var lastName: String?
    var dateOfBirth: Date?
    
    init() {
        super.init(type: .senior)
    }
}

class SeasonPassGuest: Guest, Nameable, Mailable {
    var firstName: String?
    var lastName: String?
    var address: Address?
    
    init() {
        super.init(type: .seasonPassHolder)
    }
}

// Employees
typealias Employable = Person & Nameable & Mailable

class Employee: Employable {
    
    var type: EntrantType
    var pass: ParkPass
    
    var firstName: String?
    var lastName: String?
    var address: Address?

    init(type: EntrantType.Employee) {
        self.type = EntrantType.employee(type)
        self.pass = ParkPass(holder: self.type)
        pass.holder = self
    }
    
}

class Manager: Employable {
    
    var type: EntrantType
    var pass: ParkPass
    
    var firstName: String?
    var lastName: String?
    var address: Address?
    
    init(type: EntrantType.Manager) {
        self.type = EntrantType.manager(type)
        self.pass = ParkPass(holder: self.type)
        pass.holder = self
    }
    
    deinit {
        print("These die off fine..")
    }
    
}

class Contractor: Employable {
    
    var type: EntrantType
    var pass: ParkPass
    
    var firstName: String?
    var lastName: String?
    var address: Address?
        
    init(type: EntrantType.ContractorProject) {
        self.type = EntrantType.contractor(workingOn: type)
        self.pass = ParkPass(holder: self.type)
        pass.holder = self
    }
}



// Vendor
class Vendor: Person, Nameable, AgeIdentifiable, WorkTrackable {
    var type: EntrantType
    var pass: ParkPass
    
    var firstName: String?
    var lastName: String?
    var dateOfBirth: Date?
    
    var dateOfVisit: Date
    var company: String
    
    init(company: EntrantType.AuthorisedVendorCompany) {
        self.type = EntrantType.vendor(from: company)
        self.company = company.rawValue
        self.dateOfVisit = Date()
        
        self.pass = ParkPass(holder: self.type)
        pass.holder = self
    }
}


/* old implementation

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

typealias Employable = Nameable & Mailable

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

class Person {
    var type: EntrantType
    
    init(type: EntrantType) {
        self.type = type
    }
}

let person = Person(type: EntrantType.employee(.foodServices))


class NewGuest: Person {
    
    init(type: EntrantType.Guest) {
        super.init(type: EntrantType.guest(type))
    }
}

class NewEmployee: Person {
    
    init(type: EntrantType.Employee) {
        super.init(type: EntrantType.employee(type))
    }
}
*/

