//
//  Example.swift
//  TestRealm
//
//  Created by User on 3/13/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//

import Foundation
import UIKit

public class Example {
    public static var beforeEach: (() -> ())? = nil

    public static func of(_ description: String, action: () -> ()) {
        beforeEach?()
        printHeader(description)
        action()
    }

    private static func printHeader(_ message: String) {
        print("\nℹ️ \(message):")
        let length = Float(message.count + 3) * 1.2
        print(String(repeating: "—", count: Int(length)))
    }
}
