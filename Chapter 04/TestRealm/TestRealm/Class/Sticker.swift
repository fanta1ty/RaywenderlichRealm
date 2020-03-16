//
//  Sticker.swift
//  TestRealm
//
//  Created by User on 3/16/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//  Email: thinhnguyen12389@gmail.com
//

import Foundation
import RealmSwift
import UIKit

class Sticker: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var text = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(_ text: String) {
        self.init()
        self.text = text
    }
}
