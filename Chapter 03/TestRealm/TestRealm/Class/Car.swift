//
//  Car.swift
//  TestRealm
//
//  Created by User on 3/13/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class Car: Object {
    @objc dynamic var brand = ""
    @objc dynamic var year = 0
    
    convenience init(brand: String, year: Int) {
        self.init()
        self.brand = brand
        self.year = year
    }
    
    override var description: String {
        return "🎯 {\(brand), \(year)}"
    }
}
