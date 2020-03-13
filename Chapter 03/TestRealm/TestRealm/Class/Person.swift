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
import CoreLocation

class Person: Object {
    // String
    @objc dynamic var firstName = ""
    @objc dynamic var lastName: String?
    
    // Date
    @objc dynamic var born = Date.distantPast
    @objc dynamic var deceased: Date?
    
    // Data
    @objc dynamic var photo: Data?
    
    // Bool
    @objc dynamic var isVIP: Bool = false
    
    // Int, Int8, Int16, Int32, Int64
    @objc dynamic var id = 0 // Inferred as Int
    @objc dynamic var hairCount: Int64 = 0
    
    // Float, Double
    @objc dynamic var height: Float = 0.0
    @objc dynamic var weight = 0.0 // Inferred as Double
    
    // Compound property
    private let lat = RealmOptional<Double>()
    private let lng = RealmOptional<Double>()
    
    var lastLocation: CLLocation? {
        get {
            guard let lat = lat.value, let lng = lng.value else {
                return nil
            }
            
            return CLLocation(latitude: lat, longitude: lng)
        }
        
        set {
            guard let location = newValue?.coordinate else {
                lat.value = nil
                lng.value = nil
                return
            }
            
            lat.value = location.latitude
            lng.value = location.longitude
        }
    }
    
    // Enum
    enum Department: String {
        case technology
        case politics
        case business
        case health
        case science
        case sports
        case travel
    }
    
    @objc dynamic private var _department = Department.technology.rawValue
    
    var department: Department {
        get {
            return Department(rawValue: _department)!
        }
        
        set {
            _department = newValue.rawValue
        }
    }
    
    // Computed properties
    var isDeceased: Bool {
        return deceased != nil
    }
    
    var fullName: String {
        guard let last = lastName else {
            return firstName
        }
        
        return firstName + " " + last
    }
    
    let idPropertyName = "id"
    var temporaryId = 0
    
    @objc dynamic var key = UUID().uuidString
    override class func primaryKey() -> String? {
        return "key"
    }
    
    override class func indexedProperties() -> [String] {
        return ["firstName", "lastName"]
    }
    
    @objc dynamic var temporaryUploadId = 0
    override class func ignoredProperties() -> [String] {
        return ["temporaryUploadId"]
    }
    
    convenience init(firstName: String, born: Date, id: Int) {
        self.init()
        self.firstName = firstName
        self.born = born
        self.id = id
    }
}
