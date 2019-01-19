//
//  Errors.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 18/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

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

// MARK: - Errors for Field Parsing
enum FieldParsingError: Error {
    case invalidDateOfBirth
    case childOver5
    case invalidSSN
    case missingFirstName
    case missingLastName
    case invalidCompany
    case invalidAddress
    case invalidProject
    
    
}
extension FieldParsingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidDateOfBirth:
            return "An invalid date of birth was inserted for this guest. Please enter date of birth in the format day - month - year."
        case .invalidSSN: 
            return "Social Security number is invalid. Please enter a valid number."
        case .childOver5:
            return "Child guests must be under 5 years of age to qualify for free entry."
        case .missingFirstName, .missingLastName:
            return "Please ensure that a first and last name is recorded for this guest."
        case .invalidCompany:
            return "Please ensure that a company has been entered for this entrant."
        case .invalidAddress:
            return "Please ensure that street address, city, state and zip code are all entered for this guest."
        case .invalidProject:
            return "The project identifier entered for this contractor does not match the identifier of any recent projects undertaken at this park. Please contact a manager."
        }
    }
}
