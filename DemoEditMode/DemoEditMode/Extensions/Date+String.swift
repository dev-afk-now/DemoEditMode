//
//  String+Date.swift
//  DemoEditMode
//
//  Created by Nik Dub on 24.07.2024.
//

import Foundation

extension Date {
    func asString(_ format: String = "dd-MM-YYYY") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
