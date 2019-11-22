//
//  TasksTableViewController.swift
//  SaveUserData
//
//  Created by Artjoms Vorona on 22/11/2019.
//  Copyright © 2019 Artjoms Vorona. All rights reserved.
//

import CoreData
import UIKit

class TasksTableViewController: UITableViewController {
    
    var items = [Items]()
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadData()
    }
    
    //MARK: IBActions
    
    @IBAction func addNewItemTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter the title of your task"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            let newItem = Items(context: self.context!)
            
            var title = alert.textFields?.first?.text
            switch title {
            case "":
                title = "New item"
            default:
                break
            }
            
            newItem.title = title
            self.items.append(newItem)
            self.saveData()
        }))
        present(alert, animated: true, completion:  nil)
    }
    
    //MARK: functions with Core Data
    
    func saveData() {
        
        do {
            try context?.save()
        } catch  {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func loadData() {
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        
        do {
            items = try (context?.fetch(request))!
        } catch  {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)

        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isCompleted ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Are sure you want to delete your task?", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (_) in
                let item = self.items[indexPath.row]
                self.items.remove(at: indexPath.row)
                self.context?.delete(item)
                
                self.saveData()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        items[indexPath.row].isCompleted = !items[indexPath.row].isCompleted
        saveData()
    }

}
