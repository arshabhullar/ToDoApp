//
//  Item.swift
//  ToDoApp
//
//  Created by Arsh Bhullar on 07/06/19.
//  Copyright © 2019 Arsh Bhullar. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateOfCreation : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
