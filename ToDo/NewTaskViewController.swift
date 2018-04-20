//
//  ToDoViewController.swift
//  ToDo
//
//  Created by Faraday Faraday on 09/04/2018.
//  Copyright © 2018 Faraday Faraday. All rights reserved.
//
import os.log
import UIKit

class NewTaskViewController: UIViewController, UITextFieldDelegate {
    
    var task: Task?
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var priorityButtons: PriorityButtons!
    @IBOutlet weak var priorityBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        
        // updating an alreasy existing task
        if let task = task {
            taskTextField.text = task.text
            priorityBar.backgroundColor = task.priority.color
            priorityButtons.priority = task.priority
            saveButton.isEnabled = true
        }
        
        taskTextField.delegate = self
        taskTextField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("PriorityChanged"), object: nil)
        
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        priorityBar.backgroundColor = priorityButtons.priority.color
    }
    
    
    //MARK: - Interactin with Text Field
    
    /* Performing a segue with dismissing a keybord */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if saveButton.isEnabled {
            self.performSegue(withIdentifier: "segueToMain", sender: saveButton)
        }
        return true
    }
    
    /* It's not possible to save a task if the text field is empty */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        saveButton.isEnabled = true
        
        if let text = textField.text, text.count == 1, string.isEmpty {
            saveButton.isEnabled = false
        }
        return true
    }
    
    //MARK: - Segue
    
    /*
     Prepare for segue: create a new task or update an already existing one.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
            
        }
        
        taskTextField.resignFirstResponder()
        
        if let task = task, let text = taskTextField.text, !text.isEmpty {
            task.text = text
            task.priority = priorityButtons.priority
        } else {
            if let text = taskTextField.text, !text.isEmpty {
                let priority = priorityButtons.priority
                task = Task(text: text, priority: priority)
            }
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Actions
    
    @IBAction func cancel(_ sender: Any) {
        
        taskTextField.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
        
        let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        
        if isPresentingInAddTaskMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The viewController is not inside a navigation controller.")
        }
    }
    
}

