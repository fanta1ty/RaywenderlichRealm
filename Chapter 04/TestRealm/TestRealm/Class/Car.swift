//
//  Car.swift
//  TestRealm
//
//  Created by User on 3/14/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//  Email: thinhnguyen12389@gmail.com
//

import Foundation
import RealmSwift
import UIKit

class Car: Object {
    @objc dynamic var brand = ""
    @objc dynamic var year = 0
    
    // Object relationships
    @objc dynamic var owner: Person?
    @objc dynamic var shop: RepairShop?
    
    let repairs = List<Repair>()
    let plates = List<String>()
    let checkups = List<Date>()
    let stickers = List<String>()
    
    convenience init(brand: String, year: Int) {
        self.init()
        self.brand = brand
        self.year = year
    }
    
    override var description: String {
        return "Car {\(brand), \(year)}"
    }
}
