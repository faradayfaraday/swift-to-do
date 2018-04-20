//
//  ToDoTableViewController.swift
//  ToDo
//
//  Created by Faraday Faraday on 11/04/2018.
//  Copyright © 2018 Faraday Faraday. All rights reserved.
//
import os.log
import UIKit

class ToDoTableViewController: UITableViewController {
    
    var toDo = [Task]()
    
    @IBOutlet weak var addBut: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedTasks = loadToDo() {
            toDo += savedTasks
        } else {
            loadSampleTasks()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func edit(_ sender: Any) {
        self.isEditing = !self.isEditing
        
        if self.isEditing {
            addBut.isEnabled = false
            editButton.title = "Done"
        } else {
            addBut.isEnabled = true
            editButton.title = "Edit"
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDo.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ToDoTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskTableViewCell else {
            fatalError("The dequeued cell is not an instance of ToDoTableViewCell.")
        }

        let task = toDo[indexPath.row]
        
        cell.task = task
        cell.taskTextLabel.text = task.text
        cell.priorityBar.backgroundColor = task.priority.color
        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    // Editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDo.remove(at: indexPath.row)
            saveToDo()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    
        if self.isEditing {
            return .none
        } else {
            return .delete
        }
    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /* Rearranging the table view */
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let taskToMove = toDo[fromIndexPath.row]
        toDo.remove(at: fromIndexPath.row)
        toDo.insert(taskToMove, at: to.row)
        saveToDo()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new task.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            
            guard let viewController = segue.destination as? NewTaskViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? TaskTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedTask = toDo[indexPath.row]
            viewController.task = selectedTask
            
        default: fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }
    
    @IBAction func unwindToMainView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewTaskViewController, let task = sourceViewController.task {
            
            if let selectedIndexTask = tableView.indexPathForSelectedRow {
                toDo[selectedIndexTask.row] = task
                tableView.reloadRows(at: [selectedIndexTask], with: .automatic)
            } else {
                let newIndexPath = IndexPath(row: toDo.count, section: 0)
                toDo.append(task)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveToDo()
        }
    }
    
    //MARK: - Private Methods
    
    private func saveToDo() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(toDo, toFile: Task.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Tasks saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save...", log: OSLog.default, type: .error)
        }
        
    }
    
    private func loadToDo() -> [Task]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Task.ArchiveURL.path) as? [Task]
    }
    
    private func loadSampleTasks() {
        let task1 = Task(text: "Swipe left to delete", priority: .low)
        let task2 = Task(text: "Tap to edit", priority: .medium)
        let task3 = Task(text: "Press + to add a new task", priority: .high)
        
        toDo += [task1, task2, task3]
    }

}
