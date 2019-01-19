//
//  PassGenerationViewController.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 17/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

class PassGenerationViewController: UIViewController {
    
    static let overviewSegueIdentifier = "showOverviewScreen"
    
    // Scroll View
    @IBOutlet weak var formScrollView: UIScrollView!

    // Outlet for Buttons on the Parent Selection Bar
    @IBOutlet var highLevelEntrantTypeButtons: [UIButton]!
    
    // Outlet for Buttons on the Child Selection Bar    
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
    
    // SSN Outlets
    @IBOutlet weak var ssnLabel: UILabel!
    @IBOutlet weak var ssnField: FormTextField!
    
    var socialSecurityRequired: Bool = false {
        didSet {
            setLabels([ssnLabel], toRequired: socialSecurityRequired)
            setFields([ssnField], toRequired: socialSecurityRequired)
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
    
    var entrantBeingCreated: Person?

    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PassGenerationViewController.keyboardAppeared), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PassGenerationViewController.keyboardDisappeared), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Cleanup the Form (Mainly utilized when returning from the overview view.
        entrantBeingCreated = nil
        updateFieldStates()
        clearAll()
        clearSubEntrantStack()
        resetEntrantButtons()
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
            socialSecurityRequired = false
            nameSectionRequired = false
            companySectionRequired = false
            addressSectionRequired = false
            return
        }

        dateOfBirthRequired = entrantBeingCreated is AgeIdentifiable
        projectSectionRequired = entrantBeingCreated is Contractor
        socialSecurityRequired = entrantBeingCreated is HasSocialSecurityNumber
        nameSectionRequired = entrantBeingCreated is Nameable
        companySectionRequired = entrantBeingCreated is Vendor
        addressSectionRequired = entrantBeingCreated is Mailable
    }
    
    // MARK: - Clean Up Functions
    // Clears all fields of their text
    func clearAll() {
        let fields = [dateOfBirthField, projectNumberField, companyField, ssnField] + nameFields + addressFields
        fields.forEach {
            $0.text = ""
        }
    }
    
    func resetEntrantButtons() {
        highLevelEntrantTypeButtons.forEach {
            $0.alpha = 1.0
        }
    }
    
    func clearSubEntrantStack() {
        subEntrantStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
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

        clearSubEntrantStack()
        
        subEntrants.forEach {
            let button = UIButton.createSubEntrantButton(withTitle: "\($0.rawValue)")
            button.addTarget(self, action: #selector(subEntrantSelected(_:)), for: .touchUpInside)
            subEntrantStack.addArrangedSubview(button)
        }
    }
    
    @objc func subEntrantSelected(_ sender: UIButton) {
        // Dim the other buttons.
        subEntrantStack.arrangedSubviews.forEach {
            $0.alpha = ($0 == sender) ? 1.0 : 0.5
        }
        
        clearAll()
        
        // It's relatively safe to work with this string since it comes from the ENUM raw value.
        guard let entrantDescription = sender.titleLabel?.text else { return }
        
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
            // Some Contractor
            projectNumberField.text = contractorType.rawValue // Since we know the project we can pre-fill it.
            entrantBeingCreated = Contractor(type: contractorType)
            
        } else if let vendorCompany = EntrantType.AuthorisedVendorCompany(rawValue: entrantDescription) {
            // Some Vendor
            companyField.text = vendorCompany.rawValue // Pre-fill company.
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
            
            // dump(entrantBeingCreated)
            
            presentOverviewScreen()
            
        } catch let error {
            showAlert(description: error.localizedDescription)
        }
    }
    
    @IBAction func populateData() {
        guard entrantBeingCreated != nil else {
            showAlert(description: "Please select an Entrant type before trying to populate information automatically.")
            return
        }
        
        populateFieldsUsingDummyData()
    }
    
    // MARK: - Present Overview Screen
    func presentOverviewScreen() {
        performSegue(withIdentifier: PassGenerationViewController.overviewSegueIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == PassGenerationViewController.overviewSegueIdentifier else { return }
        
        if let overviewViewController = segue.destination as? ReviewPassViewController {
            overviewViewController.entrant = entrantBeingCreated
        }
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
        }
        
        // 2. Social Security Number
        if var hasSocialSecurityNumber = entrantBeingCreated as? HasSocialSecurityNumber {
            
            guard let socialSecurityString = ssnField.text, socialSecurityString.count > 0, let socialSecurityNumber = Int(socialSecurityString) else {
                throw FieldParsingError.invalidSSN
            }
            
            hasSocialSecurityNumber.ssn = socialSecurityNumber
        }
        
        // 3. Project Number
        
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
        
        // 4. First & Last Names
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
        
        // 5. Company
        if let entrantFromCompany = entrantBeingCreated as? Vendor {
            guard let company = companyField.text, company.count > 0 else {
                throw FieldParsingError.invalidCompany
            }
            
            entrantFromCompany.company = company
        }
        
        // 6. Address
        if var entrantWithAddress = entrantBeingCreated as? Mailable {
            
            guard let address = Address(streetAddress: streetField.text, city: cityField.text, state: stateField.text, zipCodeString: zipCodeField.text) else {
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
    
    // MARK: - Deal with the Keyboard
    @objc func keyboardAppeared(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            
            formScrollView.contentInset = edgeInsets
            formScrollView.scrollIndicatorInsets = edgeInsets
        }
    }
    
    @objc func keyboardDisappeared() {
        UIView.animate(withDuration: 0.5) {
            self.formScrollView.contentInset = UIEdgeInsets.zero
            self.formScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        }
    }
}

extension PassGenerationViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension PassGenerationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
