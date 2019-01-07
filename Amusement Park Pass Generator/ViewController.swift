//
//  ViewController.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 06/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var rideFixer: Employee? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Testing Guests
        /// Regular Guest
//        let firstEverGuest = Guest()
//        PassReader.swipe(firstEverGuest.pass, forAccessTo: .parkArea(.kitchen))
//        PassReader.swipe(firstEverGuest.pass, forAccessTo: .parkArea(.amusement))
//        PassReader.swipe(firstEverGuest.pass, forAccessTo: .ride(.priorityQueueing))
        
        /// VIP Guest
//        let vipGuest = VIPGuest()
//        PassReader.swipe(vipGuest.pass, forAccessTo: .parkArea(.office))
//        PassReader.swipe(vipGuest.pass, forAccessTo: .ride(.priorityQueueing))
        
        /// Child Guests...
        /// A valid child entrant...
//        let birthDate = Calendar.current.date(from: DateComponents(year: 2015, month: 10, day: 01)) // DOB: 1st October 2015
//        let child = try! ChildGuest(dateOfBirth: birthDate)
//        PassReader.swipe(child.pass, forAccessTo: .parkArea(.kitchen))
        
        /// An invalid child entrant...
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
        
    }

}

