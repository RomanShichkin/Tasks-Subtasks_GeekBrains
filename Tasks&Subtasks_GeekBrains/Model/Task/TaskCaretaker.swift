//
//  TaskCaretaker.swift
//  Tasks&Subtasks_GeekBrains
//
//  Created by Роман Шичкин on 25.08.2021.
//

import Foundation

class TaskCaretaker {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let defaults = UserDefaults.standard
    private let taskKey = "tasks"
    private let maxIDKey = "maxID"
    
    func saveMainTask(_ task: Task) {
        do {
            let data: Memento = try encoder.encode(task)
            defaults.setValue(data, forKey: taskKey)
        } catch {
            print(error.localizedDescription)
        }
    }

    func loadMainTask() -> Task {
        guard let data: Memento = defaults.data(forKey: taskKey) else {
            return Task()
        }
        
        do {
            return try decoder.decode(Task.self, from: data)
        } catch {
            print(error.localizedDescription)
            return Task()
        }
    }
    
    func saveMaxID(_ id: Int) {
        defaults.setValue(id, forKey: maxIDKey)
    }
    
    func loadMaxID() -> Int {
        return defaults.integer(forKey: maxIDKey)
    }
}

