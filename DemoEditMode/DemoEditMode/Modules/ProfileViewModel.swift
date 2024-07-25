//
//  ProfileViewModel.swift
//  DemoEditMode
//
//  Created by Nik Dub on 24.07.2024.
//

import Foundation

class ProfileViewModelImpl: ProfileViewModel {
    private var userModel = User.empty() {
        didSet {
            print("")
        }
    }
    private var storageService: StorageService<User>
    private var storageKey = "user"
    
    init(storage: StorageService<User> = StorageService()) {
        self.storageService = storage
    }
    
    func didPickedOptionFor(
        _ property: UserProperty,
        value: String
    ) {
        switch property {
        case .fullname:
            userModel.fullname = value
        case .gender:
            userModel.gender = value
        case .birthday:
            userModel.birthday = value
        case .phoneNumber:
            userModel.phoneNumber = value
        case .email:
            userModel.email = value
        case .username:
            userModel.username = value
        case .image: break
        }
    }
    
    func validateAndSave() -> [UserProperty] {
        let filtered = UserProperty.allCases.filter {
            switch $0 {
            case .fullname:
                return userModel.fullname.isEmpty
            case .gender:
                return userModel.gender.isEmpty
            case .birthday:
                return userModel.birthday.isEmpty
            case .phoneNumber:
                return userModel.phoneNumber.isEmpty
                || !userModel.phoneNumber.isValidPhoneNumber()
            case .email:
                return userModel.email.isEmpty
            case .username:
                return userModel.username.isEmpty
            case .image:
                return false
            }
        }
        if filtered.isEmpty {
            saveUserToStorage()
        }
        return filtered
    }
    
    func didPickedImage(_ imageData: Data) {
        userModel.image = imageData
    }
    
    func getSavedUser() -> User {
        guard let user = storageService.object(for: storageKey) else {
            return userModel
        }
        userModel = user
        return userModel
    }
    
    private func saveUserToStorage() {
        storageService.saveObject(
            for: storageKey,
            value: userModel
        )
    }
}
