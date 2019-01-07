//
//  InformationRequirements.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 07/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// MARK: - Protocols describing what information an entrant must provide.
protocol AgeIdentifiable {
    var dateOfBirth: Date { get }
    
    static func isChild(dob: Date) -> Bool
}

extension AgeIdentifiable {
    static func isChild(dob: Date) -> Bool {
        // Must be less than 5.
        let currentCalendar = Calendar.current
        
        let age = currentCalendar.dateComponents([.year], from: dob, to: Date()).year ?? 0
        
        print(age)
        
        return age < 5 ? true : false
    }
}

protocol Nameable {
    var firstName: String { get }
    var lastName: String { get }
}

// Address
struct Address {
    var streetAddress: String
    var city: String
    var state: String
    var zipCode: String
}

protocol Mailable {
    var address: Address { get }
}

// MARK: - Errors describing missing information.
enum InformationError: Error {
    case missingFirstName
    case missingLastName
    
    case missingStreetAddress
    case missingCity
    case missingState
    case missingZipCode
    
    case missingBirthday
    case ageRequirementNotMet
}
