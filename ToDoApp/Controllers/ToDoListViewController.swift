//
//  ViewController.swift
//  ToDoApp
//
//  Created by Arsh Bhullar on 26/05/19.
//  Copyright © 2019 Arsh Bhullar. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //file path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        loadData()
        
    }
    
    //MARK : Tableview Datasource methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell" , for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        //MARK : To Add Checkmark on selection
         // using ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        //or a simple method
        
//        if item .done == true {
//            cell.accessoryType = .checkmark
//        }
//        else {
//            cell.accessoryType = .none
//        }
//
        
//        tableView.reloadData()
        return cell
    }
    
    //MARK : Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        
        //MARK : TO CHECK AND UNCHECK THE CELL DISTINGUISHING THE ELEMENT AT ROW

//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }
//        else {
//            itemArray[indexPath.row].done = false
//        }
        
        // better method
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
       saveData()
    }
    
    //MARK : ADD NEW ITEMS TO TODO LIST
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks add item button on uiAlert
           
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.saveData()
            
            }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new ToDo"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveData () {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error encoding item array \(error)")
        }
        
        tableView.reloadData()
        
        
    }
    
    func loadData () {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }
         catch {
                print("error decoding \(error)")
    }
    
    
    
}

}
} 
