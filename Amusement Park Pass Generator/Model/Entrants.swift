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
    var type: EntrantType { get }
    var pass: ParkPass { get set }
    
    var description: String { get }
}

// Guests
class Guest: Person {
    
    var type: EntrantType
    var pass: ParkPass
    var description: String
    
    init(type: EntrantType.Guest) {
        self.type = EntrantType.guest(type)
        self.pass = ParkPass(holder: self.type)
        description = "Park Visitor: \(type.rawValue)"
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
typealias Employable = Person & Nameable & Mailable & AgeIdentifiable & HasSocialSecurityNumber

class Employee: Employable {
    
    var type: EntrantType
    var pass: ParkPass
    var description: String
    
    var dateOfBirth: Date?
    var ssn: Int?
    
    var firstName: String?
    var lastName: String?
    var address: Address?

    init(type: EntrantType.Employee) {
        self.type = EntrantType.employee(type)
        self.pass = ParkPass(holder: self.type)
        description = "Employee: \(type.rawValue)"
        pass.holder = self
    }
    
}

class Manager: Employable {
    
    var type: EntrantType
    var pass: ParkPass
    var description: String
    
    var dateOfBirth: Date?
    var ssn: Int?
    
    var firstName: String?
    var lastName: String?
    var address: Address?
    
    init(type: EntrantType.Manager) {
        self.type = EntrantType.manager(type)
        self.pass = ParkPass(holder: self.type)
        self.description = type.rawValue
        pass.holder = self
    }
}

class Contractor: Employable {
    
    var type: EntrantType
    var pass: ParkPass
    var description: String
    
    var dateOfBirth: Date?
    var ssn: Int?
    
    var firstName: String?
    var lastName: String?
    var address: Address?
        
    init(type: EntrantType.ContractorProject) {
        self.type = EntrantType.contractor(workingOn: type)
        self.pass = ParkPass(holder: self.type)
        self.description = "Contractor working on \(type.rawValue)"
        pass.holder = self
    }
}



// Vendor
class Vendor: Person, Nameable, AgeIdentifiable, WorkTrackable {
    var type: EntrantType
    var pass: ParkPass
    var description: String
    
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
        self.description = "Authorised Vendor from \(company.rawValue)"
        pass.holder = self
    }
}
