//
//  ViewController.swift
//  ToDoApp
//
//  Created by Arsh Bhullar on 26/05/19.
//  Copyright © 2019 Arsh Bhullar. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadData()
        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        
        return cell
    }
    
    //MARK : Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        
        // TO DELETE ITEM ON SELECTION RATHER THAN TICKING
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        //MARK : TO CHECK AND UNCHECK THE CELL DISTINGUISHING THE ELEMENT AT ROW
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveData()
    }
    
    //MARK : ADD NEW ITEMS TO TODO LIST
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks add item button on uiAlert
           
           
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
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
        
        
        do {
            try context.save()
        } catch {
            print("error saving items \(error)")
        }
        
        tableView.reloadData()
        
        
    }
    
    func loadData (with request : NSFetchRequest<Item> = Item.fetchRequest() , withPredicate predicate : NSPredicate? = nil)  {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
           
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate , additionalPredicate])
        
        } else {
            
            request.predicate = categoryPredicate
            
        }
        

        do {
           
            itemArray = try context.fetch(request)
        
        }
        catch {
            
            print("error fetching data items \(error)")
        
        }


}
 
    
}

//MARK: - search bar methods

extension ToDoListViewController: UISearchBarDelegate {
    
    //to search after clicking search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate.init(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor.init(key: "title", ascending: true)]
        
        loadData(with: request , withPredicate: predicate)
        
        tableView.reloadData()
    }
    
    //to search while typing
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate.init(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor.init(key: "title", ascending: true)]
        
        loadData(with: request , withPredicate: predicate)
        
        tableView.reloadData()
    }
    
    
}
