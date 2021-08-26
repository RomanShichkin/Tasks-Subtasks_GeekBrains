//
//  TaskStorage.swift
//  Tasks&Subtasks_GeekBrains
//
//  Created by Роман Шичкин on 25.08.2021.
//

import Foundation

class TaskStorage {
    static let shared = TaskStorage()
    private init() { }
    
    private let taskCaretaker = TaskCaretaker()
    private lazy var task: Task = {
        return taskCaretaker.loadMainTask()
    }()
    
    private lazy var maxID: Int = {
        return taskCaretaker.loadMaxID()
    }()
    
    func addTask(_ newTask: Task, for mainTask: Task) {
        if mainTask.id == task.id {
            task.addSubtask(newTask)
        } else {
            for subTask in task.openAllSubtasks() {
                if subTask.id == mainTask.id {
                    subTask.addSubtask(newTask)
                    break
                }
            }
        }
        
        taskCaretaker.saveMainTask(task)
    }
    
    @discardableResult
    func removeTask(by id: Int) -> Bool {
        var isTaskRemoved = false
        
        if task.removeSubtask(by: id) {
            isTaskRemoved = true
        }
        
        if !isTaskRemoved {
            for subTask in task.openAllSubtasks() {
                if subTask.removeSubtask(by: id) {
                    isTaskRemoved = true
                    break
                }
            }
        }
        
        if isTaskRemoved {
            taskCaretaker.saveMainTask(task)
            task = taskCaretaker.loadMainTask()
        }
        
        return isTaskRemoved
    }
    
    func modifyTask(with newTask: Task) {
        var tasksArray: [Task] = task.openAllSubtasks()
        for (index, subTask) in tasksArray.enumerated() {
            if subTask.id == newTask.id {
                tasksArray[index] = newTask
                break
            }
        }
        taskCaretaker.saveMainTask(task)
    }
    
    func getMainTask() -> Task {
       return task
    }
    
    
    func getNextID() -> Int {
        maxID += 1
        taskCaretaker.saveMaxID(maxID)
        
        return maxID
    }
}
