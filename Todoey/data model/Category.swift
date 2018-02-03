//
//  Category.swift
//  Todoey
//
//  Created by Sumit Nihalani on 02/02/18.
//  Copyright © 2018 Sumit Nihalani. All rights reserved.
//

import Foundation
import RealmSwift

class Categoryy : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    //same as var arr = Array<Int>()
    
}
