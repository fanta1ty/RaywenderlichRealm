//
//  Person.swift
//  TestRealm
//
//  Created by User on 3/13/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//  Email: thinhnguyen12389@gmail.com
//

import Foundation
import RealmSwift
import UIKit

class Person: Object {
    @objc dynamic var name = ""
    
    convenience init(_ name: String) {
        self.init()
        self.name = name
    }
}
