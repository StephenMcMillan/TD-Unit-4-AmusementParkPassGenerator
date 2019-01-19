//
//  EntrantPermissions.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 17/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// MARK: - Types of Entrants & Their Permissions
typealias EntrantSubType = RawRepresentable & CaseIterable

enum EntrantType: PermissionsReadable {

    case guest(Guest)
    case employee(Employee)
    case manager(Manager)
    case contractor(workingOn: ContractorProject)
    case vendor(from: AuthorisedVendorCompany)
    
    enum Guest: String, EntrantSubType {
        case regular = "Regular"
        case vip = "VIP"
        case child = "Child"
        case seasonPassHolder = "Season Pass Holder"
        case senior = "Senior"
    }
    
    enum Employee: String, EntrantSubType {
        case foodServices = "Food Services"
        case rideServices = "Ride Services"
        case maintenance = "Park Maintenance"
    }
    
    enum Manager: String, EntrantSubType {
        case parkManager = "Park Manager"
    }
    
    enum ContractorProject: String, EntrantSubType {
        case p1001 = "P1001"
        case p1002 = "P1002"
        case p1003 = "P1003"
        case p2001 = "P2001"
        case p2002 = "P2002"
    }
    
    enum AuthorisedVendorCompany: String, EntrantSubType {
        case acme = "Acme"
        case orkin = "Orkin"
        case fedex = "FedEx"
        case nwElectrical = "NW Electrical"
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
        case .vendor(from: .acme):
            return [.kitchen]
            
        case .vendor(from: .orkin):
            return [.amusement, .rideControl, .kitchen]
            
        case .vendor(from: .fedex):
            return [.maintenance, .office]
            
        // ** CASE FOR ACCESS TO ALL AREAS ** (Highest Level of Clearance)
        case .manager, .contractor(workingOn: .p1003), .vendor(from: .nwElectrical):
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
