//
//  MainViewController.swift
//  PlayWithCoreData
//
//  Created by denis2 on 15.01.2021.
//

import UIKit
import CoreData


class MainViewController: UITableViewController {

    private var tasks: [Task] = []
        //["task A", "task B", "task C", "task D"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                context.delete(object)
            }
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = getContext()
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            tasks = try context.fetch(fetchRequest)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskTableCell", for: indexPath)

        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        return cell
    }
    

    @IBAction func addTaskButton(_ sender: Any) {
        print(#function)
        
        let alertController = UIAlertController(title: "New task", message: "Please add new task", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let tf = alertController.textFields?.first
            if let newTaskTitle = tf?.text {
                self.saveTask(withTitle: newTaskTitle)
                //self.tasks.insert(newTask, at: 0)
                self.tableView.reloadData()
            }
            
        }
        
        alertController.addTextField() { _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func saveTask(withTitle title: String) {
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else {return}
        
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        
        do {
            try context.save()
            //tasks.append(taskObject)
            tasks.insert(taskObject, at: 0)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
