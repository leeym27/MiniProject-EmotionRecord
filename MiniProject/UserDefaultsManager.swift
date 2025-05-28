//
//  UserDefaultsManager.swift
//  MiniProject
//
//  Created by 이용민 on 5/19/25.
//

import Foundation

class UserDefaultsManager {
    static let key = "mood_entries"

    static func saveEntries(_ entries: [MoodEntry]) {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func loadEntries() -> [MoodEntry] {
        if let data = UserDefaults.standard.data(forKey: key),
           let entries = try? JSONDecoder().decode([MoodEntry].self, from: data) {
            return entries
        }
        return []
    }
}
