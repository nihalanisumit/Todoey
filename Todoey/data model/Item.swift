//
//  Item.swift
//  Todoey
//
//  Created by Sumit Nihalani on 02/02/18.
//  Copyright © 2018 Sumit Nihalani. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Categoryy.self, property: "items")
}
