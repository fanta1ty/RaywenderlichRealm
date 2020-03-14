//
//  Repair.swift
//  TestRealm
//
//  Created by User on 3/14/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//  Email: thinhnguyen12389@gmail.com
//

import Foundation
import RealmSwift
import UIKit

class Repair: Object {
    @objc dynamic var date = Date()
    @objc dynamic var person: Person?
    
    convenience init(by person: Person) {
        self.init()
        self.person = person
    }
}
