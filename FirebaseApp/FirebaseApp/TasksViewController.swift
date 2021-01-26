//
//  TasksViewController.swift
//  FirebaseApp
//
//  Created by denis2 on 25.01.2021.
//

import UIKit
import Firebase

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var user: User!
    // ref of tasks
    var ref: DatabaseReference!
    var tasks = [Task]()

    @IBOutlet weak var taskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.backgroundColor = UIColor.clear
        
        guard let currentUser = Auth.auth().currentUser else {return}
        self.user = User(user: currentUser)
        self.ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] (snapshot) in
            var _tasks = [Task]()
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            
            self?.tasks = _tasks
            self?.taskTableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.ref.removeAllObservers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.textLabel?.textColor = UIColor.red
        cell.backgroundColor = UIColor.clear
        
        toggleCompleteon(cell: cell, isCompleted: task.completed)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = taskTableView.cellForRow(at: indexPath) else {return}
        
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        
        toggleCompleteon(cell: cell, isCompleted: isCompleted)
        task.ref?.updateChildValues(["completed": isCompleted])
        
    }
    
    private func toggleCompleteon(cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
    
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTaskTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New task", message: "Add new task", preferredStyle: .alert)
        
        alertController.addTextField()
        
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] (action) in
            guard let textField = alertController.textFields?.first, textField.text != "" else {return}
            
            let task = Task(title: textField.text!, userId: (self?.user.uid)!)
            
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(task.convertToDictionary())
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    

}
