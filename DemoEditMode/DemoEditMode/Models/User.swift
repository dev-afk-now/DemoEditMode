//
//  User.swift
//  DemoEditMode
//
//  Created by Nik Dub on 24.07.2024.
//

import Foundation

struct User: Codable {
    var image: Data
    var fullname: String
    var gender: String
    var birthday: String
    var phoneNumber: String
    var email: String
    var username: String
    
    static func empty() -> User {
        return User(image: Data(), fullname: "", gender: "", birthday: "", phoneNumber: "", email: "", username: "")
    }
}
