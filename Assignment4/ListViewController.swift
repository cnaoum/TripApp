//
//  ListViewController.swift
//  Assignment4
//
//  Created by Maria Leticia Leoncio Barbosa
//  Created by Carolina Naoum Junqueira.
//

import UIKit

class ListViewController: UIViewController {
    
    var tripStore : TripStore!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var totalGasLabel: UILabel!
    @IBOutlet weak var tripTableView: UITableView!
    
    // Function to convert the total gas unit from galons to liters
    func totalGasConverted (){
        var total : Double = 0
        var totalGas : String = ""
        
        for trip in tripStore.tripArray{
             total += trip.gas.toDouble()
        }
        
        totalGas = Measurement(value: total, unit: UnitVolume.gallons).converted(to: UnitVolume.liters).value.toString()
        totalGasLabel.text = "\(NSLocalizedString("Total gas used", comment: "Total Gas")): \(total.toString()) gal = \(totalGas) L"
        
    }
    
    //Edit button, added Custom navBar button to ListViewController
    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
        if tripTableView.isEditing {
            sender.title = NSLocalizedString("Edit", comment: "Edit")
            tripTableView.setEditing(false, animated: true)
        } else {
            sender.title = NSLocalizedString("Done", comment: "Done")
            tripTableView.setEditing(true, animated: true)
        }
    }
    
    @IBAction func addTrip(_sender: Any) {
        // If table is editing can not add new trip
        if (!tripTableView.isEditing) {
            let index = tripStore.tripArray.count // index for the new trip
            let indexPath = IndexPath(row: index, section: 0)
            tripTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            performSegue(withIdentifier: "TripSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tripTableView.reloadData()
        totalGasConverted()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        tripTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "TripSegue"?:
            if let row = tripTableView.indexPathForSelectedRow?.row {
                
                // if is an existing row then get the trip from the trip store, if is a new row instatiate a new trip
                let trip = row <= tripStore.tripArray.count - 1 ? tripStore.tripArray[row] : Trip()
                let detailViewController = segue.destination as! DetailViewController
                
                detailViewController.trip = trip
                detailViewController.tripStore = tripStore
                detailViewController.tripIndex = row
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}

extension ListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripStore.tripArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tripTableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! ListViewCell
        let trip = tripStore.tripArray[indexPath.row]
        cell.updateLabels()
        cell.originLabel?.text = "\(trip.origin)"
        cell.destinationLabel?.text = "\(trip.destination)"
        cell.gasLabel?.text = "\(trip.gasInLiters())"
        
        return cell
    }
}
extension ListViewController : UITableViewDelegate {
    
    // moving the row of the table
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.row == destinationIndexPath.row {
            return
        }
        let movedItem = (tripStore.tripArray[sourceIndexPath.row])
        tripStore.tripArray.remove(at: sourceIndexPath.row)
        tripStore.tripArray.insert(movedItem, at: destinationIndexPath.row)
    }
    
    // deleting the row from the table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let trip = (tripStore.tripArray[indexPath.row])
            
            let deleteString = NSLocalizedString("Delete", comment: "Delete Item")
            let title = deleteString + " \(trip.origin) \(NSLocalizedString("to", comment: "to string")) \(trip.destination)?"
            let messageString = NSLocalizedString("Are you sure you want to delete?", comment: "Delete Message")
            let ac = UIAlertController(title: title, message: messageString, preferredStyle: .actionSheet)
            
            let cancelString = NSLocalizedString("Cancel", comment: "Cancel Delete")
            let cancelAction = UIAlertAction(title: cancelString, style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: deleteString, style: .destructive, handler:
            {(action)->Void in
                let idx = self.tripStore.tripArray.firstIndex(of: trip)
                self.tripStore.tripArray.remove(at: idx!)
                self.tripTableView.deleteRows(at: [indexPath], with: .automatic)
                self.totalGasConverted()
            })
            ac.addAction(deleteAction)
            present(ac, animated: true, completion: nil)
            
        }
    }
}
