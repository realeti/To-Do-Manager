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
    func loadTasks() -> [TaskProtocol] {
        // временная реализация, возвращающая тестовую коллекцию задач
        let testTasks: [TaskProtocol] = [
            Task(title: "Купить хлеб", type: .normal, status: .complated),
            Task(title: "Убраться в комнате", type: .normal, status: .planned),
            Task(title: "Купить чернику", type: .important, status: .complated),
            Task(title: "Купить новый стул", type: .normal, status: .planned),
            Task(title: "Cделать обновление кланов", type: .important, status: .planned),
            Task(title: "Заработать миллион", type: .normal, status: .complated),
            Task(title: "Пригласить на вечеринку Алину, Джеки, Лео, Уилла, Томми", type: .important, status: .planned)
        ]
        return testTasks
    }
    func saveTasks(_ tasks: [TaskProtocol]) {}
}
