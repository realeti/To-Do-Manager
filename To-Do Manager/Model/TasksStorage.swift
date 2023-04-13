//
//  TasksStorage.swift
//  To-Do Manager
//
//  Created by Apple M1 on 13.03.2023.
//

import UIKit

// Протокол, описывающий сущность "Хранилище задач"
protocol TasksStorageProtocol {
    func loadTasks() -> [TaskProtocol]
    func saveTasks(_ tasks: [TaskProtocol])
}

// Сущность "Хранилище задач"
class TasksStorage: TasksStorageProtocol {
    // Ссылка на хранилище
    private var storage = UserDefaults.standard
    
    // Ключ, по которому будет происходить сохранение и загрузка хранилища из UserDefaults
    var storageKey: String = "tasks"
    
    // Перечисление с ключами для записи в UserDefaults
    private enum TaskKey: String {
        case title
        case type
        case status
    }
    
    func loadTasks() -> [TaskProtocol] {
        var resultTasks: [TaskProtocol] = []
        let tasksFromStorage = storage.array(forKey: storageKey) as? [[String:String]] ?? []
        for task in tasksFromStorage {
            guard let title = task[TaskKey.title.rawValue],
                  let typeRaw = task[TaskKey.type.rawValue],
                  let statusRaw = task[TaskKey.status.rawValue] else {
                continue
            }
            let type: TaskPriority = (typeRaw == "important") ? .important : .normal
            let status: TaskStatus = (statusRaw == "planned") ? .planned : .completed
            
            resultTasks.append(Task(title: title, type: type, status: status))
        }
        return resultTasks
    }
    
    func saveTasks(_ tasks: [TaskProtocol]) {
        var arrayForStorage: [[String:String]] = []
        tasks.forEach { task in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[TaskKey.title.rawValue] = task.title
            newElementForStorage[TaskKey.type.rawValue] = (task.type == .important) ? "important" : "normal"
            newElementForStorage[TaskKey.status.rawValue] = (task.status == .planned) ? "planned" : "complated"
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
}



//class TasksStorage: TasksStorageProtocol {
//    func loadTasks() -> [TaskProtocol] {
//        // временная реализация, возвращающая тестовую коллекцию задач
//        let testTasks: [TaskProtocol] = [
//            Task(title: "Купить хлеб", type: .normal, status: .complated),
//            Task(title: "Убраться в комнате", type: .normal, status: .planned),
//            Task(title: "Купить чернику", type: .important, status: .complated),
//            Task(title: "Купить новый стул", type: .normal, status: .planned),
//            Task(title: "Cделать обновление кланов", type: .important, status: .planned),
//            Task(title: "Заработать миллион", type: .normal, status: .complated),
//            Task(title: "Пригласить на вечеринку Алину, Джеки, Лео, Уилла, Томми", type: .important, status: .planned)
//        ]
//        return testTasks
//    }
//    func saveTasks(_ tasks: [TaskProtocol]) {}
//}
