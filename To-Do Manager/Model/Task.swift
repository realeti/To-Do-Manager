//
//  Task.swift
//  To-Do Manager
//
//  Created by Apple M1 on 13.03.2023.
//

import UIKit

// Тип задачи
enum TaskPriority {
    // обычная задача
    case normal
    // важная задача
    case important
}

// Cостояние задачи
enum TaskStatus {
    // запланированная
    case planned
    // завершенная
    case complated
}

// Требования протокола, описывающуего сущность "Задача"
protocol TaskProtocol {
    // название задачи
    var title: String { get set }
    // тип задачи
    var type: TaskPriority { get set }
    // cостояние задачи
    var status: TaskStatus { get set }
}

// Сущность "Задача"
struct Task: TaskProtocol {
    var title: String
    var type: TaskPriority
    var status: TaskStatus
}
