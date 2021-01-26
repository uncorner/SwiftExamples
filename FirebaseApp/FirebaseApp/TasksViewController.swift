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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        cell.textLabel?.text = "Some task"
        cell.textLabel?.textColor = UIColor.red
        cell.backgroundColor = UIColor.clear
        return cell
        
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
