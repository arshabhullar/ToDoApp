//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Arsh Bhullar on 05/06/19.
//  Copyright © 2019 Arsh Bhullar. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }
    
    

    // MARK: - Table view data source

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell" , for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

    @IBAction func addButtonPressed(_ sender: Any) {
       
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks add item button on uiAlert
            
            
            let newItem = Category(context: self.context)
            newItem.name = textField.text!
            
            self.categoryArray.append(newItem)
            self.saveData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create a new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - to save data to context
    func saveData () {
        
        
        do {
            try context.save()
        } catch {
            print("error saving items \(error)")
        }
        
        tableView.reloadData()
        
        
    }
    
    // MARK: - to load data from context view
    
    func loadData (with request : NSFetchRequest<Category> = Category.fetchRequest())  {
        
        do {
            
            categoryArray = try context.fetch(request)
            
        }
        catch {
            
            print("error fetching data items \(error)")
            
        }
        
        
    }
    
    
}


