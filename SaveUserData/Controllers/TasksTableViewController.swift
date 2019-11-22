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
    var userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadData()
        print("View will appear")
    }
    
    //MARK: IBActions
    
    @IBAction func addNewItemTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter the title of your task"
            textField.autocapitalizationType = .sentences
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
    
    func creteRandomColor() -> UIColor {
        let randomIndex = Int.random(in: 0...10)
        var color = UIColor.systemBackground
        
        switch randomIndex {
        case 1:
            color = .systemRed
        case 2:
            color = .systemBlue
        case 3:
            color = .systemFill
        case 4:
            color = .systemGray
        case 5:
            color = .systemPink
        case 6:
            color = .systemGreen
        case 7:
            color = .systemIndigo
        case 8:
            color = .systemOrange
        case 9:
            color = .systemYellow
        case 10:
            color = .systemPurple
        default:
            break
        }
        return color
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)

        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isCompleted ? .checkmark : .none

        if let randomColor = userDefaults.object(forKey: "randomTaskColor") {
            if randomColor as! Bool {
                cell.backgroundColor = creteRandomColor()
            } else {
                cell.backgroundColor = .systemBackground
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let allowDelete = userDefaults.object(forKey: "allowTaskDelete") {
            if allowDelete as! Bool {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
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
