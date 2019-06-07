//
//  Category.swift
//  ToDoApp
//
//  Created by Arsh Bhullar on 07/06/19.
//  Copyright © 2019 Arsh Bhullar. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
