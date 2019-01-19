//
//  PopulateFieldsHelper.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 19/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

fileprivate let randomDOBs = ["01 - 02 - 2004","09 - 01 - 1994","08 - 05 - 1990","09 - 08 - 2007","29 - 04 - 1993","12 - 12 - 2003","29 - 03 - 1982","05 - 07 - 1983","31 - 03 - 2015","24 - 10 - 2009","29 - 01 - 1982","30 - 06 - 2010","16 - 12 - 2016","09 - 06 - 2010","17 - 10 - 1987","10 - 05 - 2013","10 - 03 - 2009","10 - 08 - 1994","13 - 02 - 2004","11 - 10 - 1998"]
fileprivate let randomFirstNames = ["Henry", "William", "Geoffrey", "Jim", "Yvonne", "Jamie", "Leticia", "Priscilla", "Sidney", "Nancy", "Edmund", "Bill", "Megan"]
fileprivate let randomLastNames = ["Pearson", "Adams", "Cole", "Francis", "Andrews", "Casey", "Gross", "Lane", "Thomas", "Patrick", "Strickland", "Nicolas", "Freeman"]
fileprivate let randomStreetAddress = ["243 Klocko Center", "848 Dillan Track", "088 Zachery Knolls", "1614 Otis Crescent", "7016 Marvin Spring", "254 Percival Ways", "41047 Larson Haven", "940 Tyrell Falls", "019 Rylee Well", "994 Bogan Haven"]
fileprivate let randomCities = ["Abbottborough", "Watersburgh","Lake Erlingbury", "Ankundingbury", "Langfurt", "Willaland", "New Rogersville", "East Kayliemouth", "Kemmerfort", "Ednamouth"]
fileprivate let randomStates = ["South Dakota", "Rhode Island", "California", "Iowa", "Virginia", "Colorado", "Oregon", "Iowa", "California", "Missouri"]

// This wouldn't ship in the production app.
extension PassGenerationViewController {
    func populateFieldsUsingDummyData() {
        guard let entrant = entrantBeingCreated else {
            return
        }
        
        // Company and Project dont need to be populated because they are auto-filled.
        
        // 1. Prefill Date of Birth if required.
        if entrant is AgeIdentifiable {
            dateOfBirthField.text = randomDOBs.randomElement()
        }
        
        // 2. Prefill SSN if required.
        if entrant is HasSocialSecurityNumber {
            ssnField.text = "\(Int.random(in: 1000...9999))"
        }
        
        // 3. Prefill Name and last name
        if entrant is Nameable {
            firstNameField.text = randomFirstNames.randomElement()
            lastNameField.text = randomLastNames.randomElement()
        }
        
        // 5. Prefill all address elements
        if entrant is Mailable {
            streetField.text = randomStreetAddress.randomElement()
            stateField.text = randomStates.randomElement()
            cityField.text = randomCities.randomElement()
            zipCodeField.text = "\(Int.random(in: 1000...9999))"
        }
    }
}
