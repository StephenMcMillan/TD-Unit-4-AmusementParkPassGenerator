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
    var dateOfBirth: Date? { get set }
    var isBirthday: Bool { get }
    
    static func isChild(dateOfBirth: Date) -> Bool
}

extension AgeIdentifiable {
   
    static func isChild(dateOfBirth: Date) -> Bool {
        // Must be less than 5.
        let currentCalendar = Calendar.current
        let age = currentCalendar.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
        return age < 5 ? true : false
    }
    
    var isBirthday: Bool {
        let today = Date()
        let todayComponents = Calendar.current.dateComponents([.month, .day], from: today)
        
        // TODO: FIX THIS IMPLICITY UNWRAP
        let birthdayComponents = Calendar.current.dateComponents([.month, .day], from: dateOfBirth!)
        
        if todayComponents.day == birthdayComponents.day && todayComponents.month == birthdayComponents.month {
            return true
        } else {
            return false
        }
    }
}

protocol HasSocialSecurityNumber {
    var ssn: Int? { get set }
}

protocol Nameable {
    var firstName: String? { get set }
    var lastName: String? { get set }
}

// Address
struct Address {
    var streetAddress: String
    var city: String
    var state: String
    var zipCode: String
    
    // Trys to create an Address or returns nil if fields are invalid.
    init?(streetAddress: String?, city: String?, state: String?, zipCode: String?) {

        if let street = streetAddress, let city = city, let state = state, let zipCode = zipCode {

            guard street.count > 0 && city.count > 0 && state.count > 0 && zipCode.count > 0 else {
                return nil
            }

            self.streetAddress = street
            self.city = city
            self.state = state
            self.zipCode = zipCode


        } else {
            return nil
        }
    }
}

protocol Mailable {
    var address: Address? { get set }
}

protocol WorkTrackable {
    var dateOfVisit: Date { get set }
    var company: String { get set }
}
