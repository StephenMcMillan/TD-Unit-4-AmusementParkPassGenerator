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
