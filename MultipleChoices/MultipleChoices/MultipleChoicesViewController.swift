//
//  MultipleChoicesViewController.swift
//  MultipleChoices
//
//  Created by Siyang Liu on 17/3/22.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

import UIKit

class MultipleChoicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var multipleChoicesTableView: UITableView!
    
    // Arrary to store the questions
    var questions = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: TableView data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "MultipleChoicesCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MultipleChoicesCell
        
        cell.questionNumberLabel.text = "Choice \(indexPath.row + 1)"
        cell.questionContentTextField.text = questions[indexPath.row]
        // Add the tag and target-acton for the text field
        cell.questionContentTextField.tag = indexPath.row
        cell.questionContentTextField.addTarget(self, action: #selector(textDidChange(in:)), for: .editingChanged)
        
        return cell
    }
    
    // MARK: TableView delegate
    

    // MARK: - Handle the event for the button
    @IBAction func addChoiceButtonClick(_ sender: UIButton) {
        questions.append("")
        multipleChoicesTableView.reloadData()
        let indexPath = IndexPath(row: questions.count - 1, section: 0)
        multipleChoicesTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
            questions.remove(at: indexPath.row)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: - Handle the text change event
    func textDidChange(in textField: UITextField) {
        let index = textField.tag
        questions[index] = textField.text!
    }
}
