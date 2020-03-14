//
//  RepairShop.swift
//  TestRealm
//
//  Created by User on 3/14/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//  Email: thinhnguyen12389@gmail.com
//

import Foundation
import RealmSwift
import UIKit

class RepairShop: Object {
    @objc dynamic var name = ""
    @objc dynamic var contact: Person?
}
