//
//  String+isPhoneNumber.swift
//  DemoEditMode
//
//  Created by Nik Dub on 25.07.2024.
//

import Foundation

extension String {
    func isValidPhoneNumber() -> Bool {
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", Regex.phoneNumber)
        return phoneTest.evaluate(with: self)
    }
}

enum Regex {
    static let phoneNumber = "^\\+\\d{3}\\d{8,9}$"
}
