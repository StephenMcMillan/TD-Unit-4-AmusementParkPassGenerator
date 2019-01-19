//
//  ReviewPassViewController.swift
//  Amusement Park Pass Generator
//
//  Created by Stephen McMillan on 17/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

class ReviewPassViewController: UIViewController {
    
    // Person of Focus
    var entrant: Person?

    // Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var passDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var foodDiscountLabel: UILabel!
    @IBOutlet weak var merchDiscountLabel: UILabel!
    
    
    // Button Outlets
    @IBOutlet weak var amusementTestButton: UIButton!
    @IBOutlet weak var kitchenTestButton: UIButton!
    @IBOutlet weak var rideControlTestButton: UIButton!
    @IBOutlet weak var maintenanceTestButton: UIButton!
    @IBOutlet weak var officeTestButton: UIButton!
    @IBOutlet weak var priorityQueueingTestButton: UIButton!
    @IBOutlet weak var foodDiscountTestButton: UIButton!
    @IBOutlet weak var merchDiscountTestButton: UIButton!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultViewLabel: UILabel!
    
    // Colors
    let successColor = UIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)
    let failColor = UIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1.0)
    let normalColor = UIColor(red: 238/255.0, green: 236/255.0, blue: 241/255.0, alpha: 1.0)
    
    let soundManager = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup Based on the Entrant type.
    func setupView() {
        
        guard let entrant = entrant else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        if let nameableEntrant = entrant as? Nameable, let firstName = nameableEntrant.firstName, let lastName = nameableEntrant.lastName {
            nameLabel.text = "\(firstName) \(lastName)"
        } else {
            nameLabel.text = "Visitor"
        }
        
        passDescriptionLabel.text = entrant.description
        
        foodDiscountLabel.isHidden = true
        merchDiscountLabel.isHidden = true
        
        entrant.type.discountsAvailable.forEach {
            if $0.appliesTo == PurchaseType.food {
                foodDiscountLabel.isHidden = false
                foodDiscountLabel.text = "\($0.amount)% Discount on Food!"
            }
            
            if $0.appliesTo == PurchaseType.merchandise {
                merchDiscountLabel.isHidden = false
                merchDiscountLabel.text = "\($0.amount)% Discount on Merch!"
            }
        }
        
        if let entrant = entrant as? AgeIdentifiable, entrant.isBirthday {
                birthdayLabel.isHidden = false
        } else {
                birthdayLabel.isHidden = true
        }
        
        resultView.backgroundColor = normalColor
        resultViewLabel.alpha = 0
    }
    
    // MARK: - Testing buttons
    @IBAction func testAccessPressed(_ sender: UIButton) {
        
        guard let entrant = entrant else { return }
        
        var accessAreaRequired: AccessArea?
        var discountRequested: PurchaseType?
        
        switch sender {
        case amusementTestButton:
            accessAreaRequired = AccessArea.parkArea(.amusement)
        case kitchenTestButton:
            accessAreaRequired = AccessArea.parkArea(.kitchen)
        case rideControlTestButton:
            accessAreaRequired = AccessArea.parkArea(.rideControl)
        case maintenanceTestButton:
            accessAreaRequired = AccessArea.parkArea(.maintenance)
        case officeTestButton:
            accessAreaRequired = AccessArea.parkArea(.office)
        case priorityQueueingTestButton:
            accessAreaRequired = AccessArea.ride(.priorityQueueing)
        case foodDiscountTestButton:
            discountRequested = PurchaseType.food
        case merchDiscountTestButton:
            discountRequested = PurchaseType.merchandise
        default:
            break
        }
        
        if let accessArea = accessAreaRequired {
            let result = PassReader.swipe(entrant.pass, forAccessTo: accessArea)
            triggerResultView(result: result)
        } else if let purchaseType = discountRequested {
            let result = KioskCashRegister.swipe(entrant.pass, forPurchaseOf: purchaseType)
            triggerResultView(result: result)
        }
    }
    
    
    // MARK: - Create New Pass Button
    @IBAction func createNewPass() {
        entrant = nil
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Result View
    func triggerResultView(result: SwipeResult) {

        guard result != SwipeResult.timedOut else {
            showTimedOutAlert()
            return
        }
        
        var resultText: String
        var resultColor: UIColor
        
        switch result {

        case .accessGranted:
            resultText = "Access Granted!"
            resultColor = successColor
            soundManager.play(.success)

        case .accessDenied:
            resultText = "Access Denied!"
            resultColor = failColor
            soundManager.play(.failure)
            
        case .discountAvailable(let discount):
            resultText = "\(discount.amount)% available on \(discount.appliesTo.rawValue)! 🎉"
            resultColor = successColor
            soundManager.play(.success)

        case .noDiscount:
            resultText = "No Discount. 😌"
            resultColor = failColor
            soundManager.play(.failure)
            
        default:
            fatalError("This should never happen...")
        }
        
        resultView.backgroundColor = resultColor
        resultViewLabel.textColor = .white
        resultViewLabel.alpha = 1.0

        resultViewLabel.text = resultText

        UIView.animate(withDuration: 4.0, delay: 1.0, options: [.curveEaseIn], animations: {
            self.resultView.backgroundColor = self.normalColor
            self.resultViewLabel.alpha = 0.0
        }, completion: nil)
    }
    
    // MARK: - Alert View
    func showTimedOutAlert() {
        let alert = UIAlertController(title: "Timed Out!", message: "Please wait 5 seconds after swiping your pass before swiping again. Thank You.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
