//
//  DetailViewController.swift
//  Assignment4
//
//  Created by Maria Leticia Leoncio Barbosa
//  Created by Carolina Naoum Junqueira.
//

import UIKit

class DetailViewController: UIViewController {
    var trip : Trip!
    var tripStore : TripStore!
    var tripIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var origin: UITextField!
    @IBOutlet weak var destination: UITextField!
    @IBOutlet weak var gas: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var originText : String = ""
    var errorMessage : String = ""
    var destinationText : String = ""
    var gasText : Double = 0
    
    @IBAction func backgroungTapped(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        origin.text = trip.origin
        destination.text = trip.destination
        gas.text = trip.gas
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        
        trip.origin = originText
        trip.destination = destinationText
        trip.gas = gasText.toString()
        
        // if is a new trip, insert it to the trip store
        if tripStore.tripArray.count - 1 < tripIndex {
            tripStore.tripArray.append(trip)
        }
        
        let success = tripStore.saveChanges()
        if success {
            print("All trips saved successfully")
        } else {
            print("Trip save failed")
        }
    }
    
    // validation for the user inputs
    func validateData() -> Bool {
        var dataIsValid = true
        errorMessage = ""
        originText = origin.text!
        destinationText = destination.text!
        
        // origin input not empty and does not contain symbols or numbers
        if var originInput = origin.text, originInput.trimmingCharacters(in: .whitespacesAndNewlines).count != 0, !originInput.containsSymbols(), !originInput.containsNumbers() {
            
            originInput = originInput.trimmingCharacters(in: .whitespacesAndNewlines)
            
            originText = originInput
            
            // searching if origin already exists
            let repeatedIndex = tripStore.tripArray.indices.filter { (arrayIndex) -> Bool in
                return arrayIndex != tripIndex && tripStore.tripArray[arrayIndex].origin.caseInsensitiveCompare(originInput) == ComparisonResult.orderedSame
            }
            
            // if origin already exists, is not valid
            if repeatedIndex.count > 0 {
                let uniqueOriginMsg = NSLocalizedString("Origin input must be unique", comment: "Origin unique error")
                errorMessage = "\(errorMessage)\(uniqueOriginMsg)\n"
                dataIsValid = false
                
            } else { // origin is valid
                originText = originInput
            }
            
        } else { // origin is not valid
            let emptyOriginMsg = NSLocalizedString("Origin input field is invalid", comment: "Origin invalid error")
            errorMessage = "\(errorMessage)\(emptyOriginMsg)\n"
            dataIsValid = false
        }
        
        // destination input not empty and does not contain symbols or numbers
        if var destinationInput = destination.text, destinationInput.trimmingCharacters(in: .whitespacesAndNewlines).count != 0, !destinationInput.containsSymbols(), !destinationInput.containsNumbers() {
            
            destinationInput = destinationInput.trimmingCharacters(in: .whitespacesAndNewlines)
            
            destinationText = destinationInput
            
            // searching if destination already exists
            let repeatedIndex = tripStore.tripArray.indices.filter { (arrayIndex) -> Bool in
                return arrayIndex != tripIndex && tripStore.tripArray[arrayIndex].destination.caseInsensitiveCompare(destinationInput) == ComparisonResult.orderedSame
            }
            
            // if destination already exists, is not valid
            if repeatedIndex.count > 0 {
                let uniqueDestinationMsg = NSLocalizedString("Destination input must be unique", comment: "Destination unique error")
                errorMessage = "\(errorMessage)\(uniqueDestinationMsg)\n"
                dataIsValid = false
                
            } else { // destination is valid
                destinationText = destinationInput
            }
        } else { // destination is not valid
            let emptyDestinationMsg = NSLocalizedString("Destination input field is invalid", comment: "Destination invalid error")
            errorMessage = "\(errorMessage)\(emptyDestinationMsg)\n"
            dataIsValid = false
        }
        
        // gas input not empty
        if var gasInput = gas.text, gasInput.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 {
            
            gasInput = gasInput.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // gas input must be a valid double grater than zero and less than 2000
            let formatter = NumberFormatter()
            if let gas = formatter.number(from: gasInput)?.doubleValue, gas > 0, gas < 2000 {
                gasText = gas
                
            } else { // gas is not valid
                let invalidGasMessage = NSLocalizedString("Gas input field has invalid number", comment: "Invalid Number")
                errorMessage = "\(errorMessage)\(invalidGasMessage)\n"
                dataIsValid = false
            }
        } else { // gas is not valid
            let emptyGasMessage = NSLocalizedString("Gas input field is empty", comment: "Gas Empty")
            errorMessage = "\(errorMessage)\(emptyGasMessage)\n"
            dataIsValid = false
        }
        
        // checking if origin is different from the destination
        if (originText.caseInsensitiveCompare(destinationText) == ComparisonResult.orderedSame) {
            let originDestinationMatchMsg = NSLocalizedString("Origin and Destination cannot be the same", comment: "Origin and Destination Match")
            errorMessage = "\(errorMessage)\(originDestinationMatchMsg)\n"
            dataIsValid = false
        }
        
        errorMessageLabel.text = errorMessage
        
        return dataIsValid
    }
}

extension DetailViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
