//
//  Task.swift
//  Tasks&Subtasks_GeekBrains
//
//  Created by Роман Шичкин on 25.08.2021.
//

import Foundation

protocol TaskProtocol {
    func addSubtask(_ newTask: Task)
    func removeSubtask(by id: Int) -> Bool
    func openSubtasks() -> [Task]
}

final class Task: TaskProtocol {
    let id: Int
    var text: String = ""
    var isCompleted: Bool = false
    
    private var subTasks: [Task] = []
    
    func addSubtask(_ newTask: Task) {
        subTasks.append(newTask)
    }
    
    func removeSubtask(by id: Int) -> Bool {
        var isSubTasksContains = false
        var indexToRemove: Int = -1
        for (index, subTask) in subTasks.enumerated() {
            if subTask.id == id {
                indexToRemove = index
                isSubTasksContains = true
                break
            }
        }
        
        if isSubTasksContains {
            subTasks.remove(at: indexToRemove)
        }
        
        return isSubTasksContains
    }
    
    func openSubtasks() -> [Task] {
        return subTasks
    }
    
    func openAllSubtasks() -> [Task] {
        var tasks: [Task] = []
        for subTask in subTasks {
            tasks.append(subTask)
            tasks.append(contentsOf: subTask.openAllSubtasks())
        }
        return tasks
    }
    
    init(text: String) {
        self.id = TaskStorage.shared.getNextID()
        self.isCompleted = false
        self.text = text
    }
    
    init() {
        self.id = 0
        self.isCompleted = false
        self.text = ""
    }
}

typealias Memento = Data

extension Task: Codable { }

extension Task: CustomStringConvertible {
    var description: String {
        return "\nTask\nid: \(id)\ntext: \(text)\nisCompleted: \(isCompleted)"
    }
}
