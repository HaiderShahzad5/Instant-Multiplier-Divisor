//
//  ViewController.swift
//  TableViewApp2
//
//  Created by Haider on 24/10/2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func goButtonPressed(_ sender: Any) {
        updateTable()
        inputTextField.resignFirstResponder()
    }
    var multiplier: Int = 1
    var multiplicationResults: [String] = []
    var divisionResults: [String] = []

    func updateTable() {
        guard let inputText = inputTextField.text, let inputNumber = Int(inputText) else {
            // Handle invalid input
            return
        }
        
        multiplier = inputNumber
        multiplicationResults = (1...30).map { "\($0) x \(multiplier) = \($0 * multiplier)" }
        divisionResults = (1...30).map { "\(multiplier) / \($0) = \(String(format: "%.4f", Double(multiplier) / Double($0)))" }
        tableView.isHidden = false
        tableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return multiplicationResults.count
        }else if section == 1{
            return divisionResults.count
        }else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = multiplicationResults[indexPath.row]
        } else {
            cell.textLabel?.text = divisionResults[indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Multiplication Table" : "Division Table"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            tableViewBottom.constant = keyboardHeight
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // Revert any changes made when keyboard was shown
        tableViewBottom.constant = 0
    }

}
