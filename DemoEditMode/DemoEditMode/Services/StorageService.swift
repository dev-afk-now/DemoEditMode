//
//  StorageService.swift
//  DemoEditMode
//
//  Created by Nik Dub on 25.07.2024.
//

import Foundation

final class StorageService<T: Codable> {
    private let storage = UserDefaults.standard
    
    func object(for key: String) -> T? {
        return try? JSONDecoder().decode(T.self, from: storage.data(forKey: key) ?? Data())
    }
    
    @discardableResult
    func saveObject(for key: String, value: T) -> Bool {
        guard let encoded = try? JSONEncoder().encode(value) else {
            return false
        }
        storage.setValue(encoded, forKey: key)
        return true
    }
}
