//
//  Tests.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 07/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

class Test {
    static func run() {
        // MARK: - Testing Guests
        /// Regular Guest
//        let firstEverGuest = Guest()
//        PassReader.swipe(firstEverGuest.pass, forAccessTo: .parkArea(.kitchen))
//        PassReader.swipe(firstEverGuest.pass, forAccessTo: .parkArea(.amusement))
//        PassReader.swipe(firstEverGuest.pass, forAccessTo: .ride(.priorityQueueing))
//        KioskCashRegister.swipe(firstEverGuest.pass, forPurchaseOf: .food)
//
        // VIP Guest
//        let vipGuest = VIPGuest()
//        PassReader.swipe(vipGuest.pass, forAccessTo: .parkArea(.office))
//        PassReader.swipe(vipGuest.pass, forAccessTo: .ride(.priorityQueueing))
//        KioskCashRegister.swipe(vipGuest.pass, forPurchaseOf: .merchandise)
        
        // Child Guests...
        // A valid child entrant...
//        let birthDate = Calendar.current.date(from: DateComponents(year: 2015, month: 10, day: 01)) // DOB: 1st October 2015
//        let child = try! ChildGuest(dateOfBirth: birthDate)
//        PassReader.swipe(child.pass, forAccessTo: .parkArea(.kitchen))
//        KioskCashRegister.swipe(child.pass, forPurchaseOf: .food)
        
        
        // An invalid child entrant...
//        let anotherBirthDate = Calendar.current.date(from: DateComponents(year: 2004, month: 02, day: 23)) // DOB: 23rd Feb 2004
//
//        do {
//            let teenager = try ChildGuest(dateOfBirth: anotherBirthDate)
//        } catch InformationError.ageRequirementNotMet {
//            print("This person is underage, they are not valid to enter as a child.")
//        } catch {
//            print(error)
//        }
        
        // MARK: - Testing Employees
//        let burgerShackEmployee = try! Employee(type: .employee(.foodServices), firstName: "Jordan", lastName: "Armstrong", streetAddress: "2 Shackle Lane", city: "Cupertino", state: "California", zipCode: "CA 1021")
//        PassReader.swipe(burgerShackEmployee.pass, forAccessTo: .parkArea(.kitchen))
//        PassReader.swipe(burgerShackEmployee.pass, forAccessTo: .parkArea(.maintenance))
//        KioskCashRegister.swipe(burgerShackEmployee.pass, forPurchaseOf: .food)
        
//        let maintenanceEmployee = try! Employee(type: .employee(.maintenance), firstName: "Rachel", lastName: "Bobins", streetAddress: "31 Handyman Lane", city: "Cupertino", state: "California", zipCode: "CA 123")
//        PassReader.swipe(maintenanceEmployee.pass, forAccessTo: .ride(.priorityQueueing))
//        PassReader.swipe(maintenanceEmployee.pass, forAccessTo: .parkArea(.maintenance))
//        KioskCashRegister.swipe(maintenanceEmployee.pass, forPurchaseOf: .merchandise)
        
        // Failing employee
//        do {
//            let rideServicesEmployee = try Employee(type: .employee(.rideServices), firstName: "Alex", lastName: "Woodward", streetAddress: "102 Beechwood", city: nil, state: "California", zipCode: "CA 4231")
//            PassReader.swipe(rideServicesEmployee.pass, forAccessTo: .parkArea(.rideControl))
//            KioskCashRegister.swipe(rideServicesEmployee.pass, forPurchaseOf: .food)
//        } catch {
//            // This could be propogated to the user of the app by highlighting the missing field on a future UI.
//            print(error)
//        }
        
        // MARK: - Manager Test
//        let theBoss = try! Employee(type: .manager(.parkManager), firstName: "Kelly", lastName: "Underwood", streetAddress: "63 Rivenwood", city: "San Jose", state: "California", zipCode: "SJ 2132")
//        PassReader.swipe(theBoss.pass, forAccessTo: .parkArea(.office))
//        PassReader.swipe(theBoss.pass, forAccessTo: .ride(.all))
//        PassReader.swipe(theBoss.pass, forAccessTo: .parkArea(.kitchen))
//        KioskCashRegister.swipe(theBoss.pass, forPurchaseOf: .food)
        
        // MARK: - Birthday Test and Pass Timer test
        // Since Date() is today then this will show the happy birthday message.
//        let child2 = try! ChildGuest(dateOfBirth: Date())
//        PassReader.swipe(child2.pass, forAccessTo: .parkArea(.amusement))
//        PassReader.swipe(child2.pass, forAccessTo: .parkArea(.kitchen)) // This will fail and call below will succeed..
//
//        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { (timer) in
//            timer.invalidate()
//            PassReader.swipe(child2.pass, forAccessTo: .ride(.all))
//        }

    }
}
