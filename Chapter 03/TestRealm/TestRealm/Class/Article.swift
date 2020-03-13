//
//  Article.swift
//  TestRealm
//
//  Created by User on 3/13/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

@objcMembers class Article: Object {
    dynamic var id = 0
    dynamic var title: String?
}
