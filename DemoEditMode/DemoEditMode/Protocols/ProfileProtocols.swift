//
//  ProfileProtocols.swift
//  DemoEditMode
//
//  Created by Nik Dub on 24.07.2024.
//

import Foundation

protocol ProfileViewModel {
    func didPickedOptionFor(_ property: UserProperty, value: String)
    func didPickedImage(_ imageData: Data)
    func getSavedUser() -> User
    @discardableResult
    func validateAndSave() -> [UserProperty]
}

enum UserProperty: CaseIterable {
    case image
    case fullname
    case gender
    case birthday
    case phoneNumber
    case email
    case username
}
