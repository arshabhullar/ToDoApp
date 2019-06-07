//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Arsh Bhullar on 05/06/19.
//  Copyright © 2019 Arsh Bhullar. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    
    let realm = try! Realm()
    var toDoCategories : Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }
    
    

    // MARK: - Table view data source

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoCategories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell" , for: indexPath)
        cell.textLabel?.text = toDoCategories?[indexPath.row].name ?? "No Categories Added Yet"
        return cell
        
    }
    
    // MARK: - delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = toDoCategories?[indexPath.row]
        }
    }

    @IBAction func addButtonPressed(_ sender: Any) {
       
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks add item button on uiAlert
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create a new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - to save data to context
    func save (category : Category) {
        
        
        do {
            try realm.write {
                realm.add(category)
                
            }
        } catch {
            print("error saving items \(error)")
        }
        
        tableView.reloadData()
        
        
    }
    
    // MARK: - to load data from realm
    
    func loadData ()  {
        
        toDoCategories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    
}

extension CategoryViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        toDoCategories = toDoCategories?.filter("name CONTAINS[cd] %@", searchBar.text!)
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        tableView.reloadData()
    }
    
    
}


