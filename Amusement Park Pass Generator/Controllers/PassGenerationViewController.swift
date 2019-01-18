//
//  PassGenerationViewController.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 17/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

class PassGenerationViewController: UIViewController {

    // Outlet for Buttons on the Parent Selection Bar
    @IBOutlet var highLevelEntrantTypeButtons: [UIButton]!
    
    
    // Outlet for Buttons on the Child Selection Bar    
    @IBOutlet weak var subEntrantStackContainer: UIView!
//    var someStack: UIStackView?
    @IBOutlet weak var subEntrantStack: UIStackView!
    
    // MARK: - Form Outlets
    
    // Date of Birth Section Outlets
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var dateOfBirthField: FormTextField!
    
    var dateOfBirthRequired: Bool = false {
        didSet {
            setLabels([dateOfBirthLabel], toRequired: dateOfBirthRequired)
            setFields([dateOfBirthField], toRequired: dateOfBirthRequired)
        }
    }
    
    // Project Section Outlets
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var projectNumberField: FormTextField!
    
    var projectSectionRequired: Bool = false {
        didSet {
            setLabels([projectLabel], toRequired: projectSectionRequired)
            setFields([projectNumberField], toRequired: projectSectionRequired)
        }
    }
    
    // Name Section Outlets
    @IBOutlet var nameLabels: [UILabel]!
    @IBOutlet weak var firstNameField: FormTextField!
    @IBOutlet weak var lastNameField: FormTextField!
    @IBOutlet var nameFields: [FormTextField]!
    
    var nameSectionRequired: Bool = false {
        didSet {
            setLabels(nameLabels, toRequired: nameSectionRequired)
            setFields(nameFields, toRequired: nameSectionRequired)
        }
    }
    
    // Company Section Outlets
    @IBOutlet weak var companyField: FormTextField!
    @IBOutlet weak var companyLabel: UILabel!
    
    var companySectionRequired: Bool = false {
        didSet {
            setLabels([companyLabel], toRequired: companySectionRequired)
            setFields([companyField], toRequired: companySectionRequired)
        }
    }
    
    // Address Section Outlets
    @IBOutlet var addressLabels: [UILabel]!
    @IBOutlet weak var streetField: FormTextField!
    @IBOutlet weak var cityField: FormTextField!
    @IBOutlet weak var stateField: FormTextField!
    @IBOutlet weak var zipCodeField: FormTextField!
    @IBOutlet var addressFields: [FormTextField]!
    
    var addressSectionRequired: Bool = false{
        didSet {
            setLabels(addressLabels, toRequired: addressSectionRequired)
            setFields(addressFields, toRequired: addressSectionRequired)
        }
    }
    
    // -------
    
    var entrantBeingCreated: Person?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateFieldStates()
    }
    
    // MARK: - Form Highlighting / Unhighlighting Helpers
    func setLabels(_ labels: [UILabel], toRequired required: Bool) {
        labels.forEach { $0.alpha = required ? 1.0 : 0.5 }
    }
    
    func setFields(_ fields: [FormTextField], toRequired required: Bool) {
        fields.forEach { $0.isRequired = required }
    }
    
    func updateFieldStates() {
        guard let entrantBeingCreated = entrantBeingCreated else {
            dateOfBirthRequired = false
            projectSectionRequired = false
            nameSectionRequired = false
            companySectionRequired = false
            addressSectionRequired = false
            return
        }

        dateOfBirthRequired = entrantBeingCreated is AgeIdentifiable
        projectSectionRequired = entrantBeingCreated is Contractor
        nameSectionRequired = entrantBeingCreated is Nameable
        companySectionRequired = entrantBeingCreated is Vendor
        addressSectionRequired = entrantBeingCreated is Mailable
    }
    
    // Clears all fields of their text
    func clearAll() {
        let fields = [dateOfBirthField, projectNumberField, companyField] + nameFields + addressFields
        fields.forEach {
            $0.text = ""
        }
    }
    
    // MARK: - Entrant Type Selection Bars
    @IBAction func entrantTypeSelected(_ sender: UIButton) {
        
        highLevelEntrantTypeButtons.forEach {
            $0.alpha = ($0 == sender) ? 1.0 : 0.5
        }
        
        // Entrant buttons have a tag that correspond to an entrant type.
        switch sender.tag {
        case 0:
            layoutSubEntrantSelectionButtons(using: EntrantType.Guest.allCases)
        case 1:
            layoutSubEntrantSelectionButtons(using: EntrantType.Employee.allCases)
        case 2:
            layoutSubEntrantSelectionButtons(using: EntrantType.Manager.allCases)
        case 3:
            layoutSubEntrantSelectionButtons(using: EntrantType.ContractorProject.allCases)
        case 4:
            layoutSubEntrantSelectionButtons(using: EntrantType.AuthorisedVendorCompany.allCases)
        default:
            break
        }
    }
    
    // Logic for laying out the various sub-entrant buttons (these vary depending on the parent entrant selected)
    func layoutSubEntrantSelectionButtons<SubEntrant: EntrantSubType>(using subEntrants: [SubEntrant]) {
        // Clear Existing Sub-Entrant Buttons
        subEntrantStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        subEntrants.forEach {
            let button = UIButton.createSubEntrantButton(withTitle: "\($0.rawValue)")
            button.addTarget(self, action: #selector(subEntrantSelected(_:)), for: .touchUpInside)
            subEntrantStack.addArrangedSubview(button)
        }
        
    }
    
    @objc func subEntrantSelected(_ sender: UIButton) {
        // Need to determine what type of person we're creating, this is gonna get realllll long...
        
        // Dim the other buttons.
        subEntrantStack.arrangedSubviews.forEach {
            $0.alpha = ($0 == sender) ? 1.0 : 0.5
        }
        
        clearAll()
        
        // It's relatively safe to work with this string since it comes from the ENUM raw value.
        guard let entrantDescription = sender.titleLabel?.text else { return }
        print(entrantDescription)
        
        if let guestType = EntrantType.Guest(rawValue: entrantDescription) {
            
            // The Button was for some Guest...
            switch guestType {
            case let guest where (guest == .regular || guest == .vip):
                entrantBeingCreated = Guest(type: guest)
            
            case .child:
                entrantBeingCreated = ChildGuest()

            case .senior:
                entrantBeingCreated = SeniorGuest()

            case .seasonPassHolder:
                entrantBeingCreated = SeasonPassGuest()

            default:
                break
            }

        } else if let employeeType = EntrantType.Employee(rawValue: entrantDescription) {
            // The Button was for some Guest...
            entrantBeingCreated = Employee(type: employeeType)

        } else if let managerType = EntrantType.Manager(rawValue: entrantDescription) {
            // Some Manager
            entrantBeingCreated = Manager(type: managerType)

        } else if let contractorType = EntrantType.ContractorProject(rawValue: entrantDescription) {
            projectNumberField.text = contractorType.rawValue
            entrantBeingCreated = Contractor(type: contractorType)
            
        } else if let vendorCompany = EntrantType.AuthorisedVendorCompany(rawValue: entrantDescription) {
            // Some Vendor
            entrantBeingCreated = Vendor(company: vendorCompany)
        }
        
        updateFieldStates()
        
    }
    
    
    
    // MARK: - Bottom Button Actions
    @IBAction func generatePass() {
        
        // Check that we have all the information required by the type.
            // Check that fields are not empty or invalid
            // - No empty fields
            // - Date of Birth must be valid if required.
            // - Max Length on name and
        
        guard entrantBeingCreated != nil else {
            showAlert(description: "Please select a type of entrant to assign a Park Pass to.")
            return
        }
        
        do {
            try parseFieldData()
            
            dump(entrantBeingCreated)
            
        } catch let error {
            let a = error.localizedDescription
            print(a)
            showAlert(description: a)
        }
    }
    
    @IBAction func populateData() {
    }
    
    // Mark: - Perform checks on the fields
    func parseFieldData() throws {
        
        // 1. Date of Birth
        if var entrantWithAge = entrantBeingCreated as? AgeIdentifiable {
            
            guard let dateOfBirthString = dateOfBirthField.text, let dateOfBirth = Date.create(from: dateOfBirthString) else {
                throw FieldParsingError.invalidDateOfBirth
            }
            
            if entrantWithAge is ChildGuest {
                guard ChildGuest.isChild(dateOfBirth: dateOfBirth) else {
                    throw FieldParsingError.childOver5
                }
            }
            
            entrantWithAge.dateOfBirth = dateOfBirth
            print(dateOfBirth)
        }
        
        // 2. Project Number
        
        if let contractor = entrantBeingCreated as? Contractor {
            
            guard let projectNumber = projectNumberField.text else {
                throw FieldParsingError.invalidProject
            }
            
            if let contractorDetails = EntrantType.ContractorProject(rawValue: projectNumber) {
                contractor.type = .contractor(workingOn: contractorDetails)
            } else {
                throw FieldParsingError.invalidProject
            }
            
        }
        
        // 3. First & Last Names
        if var entrantWithName = entrantBeingCreated as? Nameable {
            
            guard let firstName = firstNameField.text, firstName.count > 0 else {
                throw FieldParsingError.missingFirstName
            }
            
            guard let lastName = lastNameField.text, lastName.count > 0 else {
                throw FieldParsingError.missingLastName
            }
            
            entrantWithName.firstName = firstName
            entrantWithName.lastName = lastName
        }
        
        // 4. Company
        // TODO: ADD THIS
        
        // 5. Address
        if var entrantWithAddress = entrantBeingCreated as? Mailable {
            
            guard let address = Address(streetAddress: streetField.text, city: cityField.text, state: stateField.text, zipCode: zipCodeField.text) else {
                throw FieldParsingError.invalidAddress
            }
            
            entrantWithAddress.address = address
        }
    }
    
    // MARK: - Display Alert
    func showAlert(description: String) {
        let alert = UIAlertController(title: "Oh No!", message: description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension Date {
    static func create(from stringRepresentation: String) -> Date? {
        let dateFormtatter = DateFormatter()
        dateFormtatter.dateFormat = "dd - MM - yyyy"
        return dateFormtatter.date(from: stringRepresentation)
    }
}

enum FieldParsingError: Error {
    case invalidDateOfBirth
    case childOver5
    case missingFirstName
    case missingLastName
    case invalidAddress
    case invalidProject
    
    
}
extension FieldParsingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidDateOfBirth:
            return "An invalid date of birth was inserted for this guest. Please enter date of birth in the format day - month - year."
        case .childOver5:
            return "Child guests must be under 5 years of age to qualify for free entry."
        case .missingFirstName, .missingLastName:
            return "Please ensure that a first and last name is recorded for this guest."
        case .invalidAddress:
            return "Please ensure that street address, city, state and zip code are all entered for this guest."
        case .invalidProject:
            return "The project identifier entered for this contractor does not match the identifier of any recent projects undertaken at this park. Please contact a manager."
        }
    }
}
