//
//  SwipeTableViewController.swift
//  ToDoApp
//
//  Created by Arsh Bhullar on 08/06/19.
//  Copyright © 2019 Arsh Bhullar. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController , SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //swipeCell delegate methods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
            guard  orientation == .right else {
                return nil
            }
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") {
                (action, indexPath) in
                //handle action by updating model with deletion
                
                self.update(at: indexPath)
                
            }
            
            deleteAction.image = UIImage.init(named: "deleteIcon")
            
            return [deleteAction]
            
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    

    

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }

    
    func update(at indexPath : IndexPath) {
        
        //update our data model
        
    }
    

}
