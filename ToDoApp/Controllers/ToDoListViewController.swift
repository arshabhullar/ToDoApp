//
//  ViewController.swift
//  ToDoApp
//
//  Created by Arsh Bhullar on 26/05/19.
//  Copyright © 2019 Arsh Bhullar. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var toDoItems : Results<Item>?
    
    var selectedCategory : Category? {
        didSet {
            loadData()
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80.00
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        
        title = selectedCategory?.name
        guard let colorHex = selectedCategory?.color else { fatalError()}
          updatNavigationBar(withHexCode: colorHex)
        
            
        
            
       
                
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updatNavigationBar(withHexCode: "1D9BF6")
        
    }
    
    
    //MARK : Tableview Datasource methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count))
            {
            
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
            
            }
            //MARK : To Add Checkmark on selection
            // using ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
            
        }
        else {
            
            cell.textLabel?.text = "No Items Added"
            
        }
        
        
        
        return cell
    }
    
    //MARK : Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //MARK : TO CHECK AND UNCHECK THE CELL DISTINGUISHING THE ELEMENT AT ROW
       
        
        do {
            try realm.write {
                
                
                //to delete items from realm database
                //realm.delete(toDoItems[indexPath.row])
                
                
                toDoItems![indexPath.row].done = !toDoItems![indexPath.row].done
            }
        } catch {
            print("error updating item done bool\(error)")
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //tableView.reloadData()
        //to make the animation noticeable used this instead of reloadTableData()
        tableView.cellForRow(at: indexPath)?.accessoryType = toDoItems![indexPath.row].done ? .checkmark : .none
    }
    
    //MARK : ADD NEW ITEMS TO TODO LIST
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks add item button on uiAlert
           
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateOfCreation = Date()
                    currentCategory.items.append(newItem)
                    print("successfully saved items")
                    }
                } catch {
                    print("error saving items \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new ToDo"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    

    func loadData ()  {
        
       toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
    
    override func update(at indexPath: IndexPath) {
        if let itemToBeDeleted = self.toDoItems?[indexPath.row] {
            
            
            do {
                try realm.write {
                    realm.delete(itemToBeDeleted)
                    print("successfully deleted the item")
                }
            } catch {
                print("error deleting the item\(error)")
            }
            
            
        }
    }
    
}

//MARK: - search bar methods

extension ToDoListViewController: UISearchBarDelegate {

    //to search after clicking search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    //to search while typing
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        tableView.reloadData()
    }

    //MARK :- NavBar setup code methods
    
    func updatNavigationBar(withHexCode colorHexCode : String) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("navigation controller does not exist")
        }
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        searchBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(backgroundColor: navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(backgroundColor: navBarColor, returnFlat: true)]
    }
    

}
