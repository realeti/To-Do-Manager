//
//  Task.swift
//  To-Do Manager
//
//  Created by Apple M1 on 13.03.2023.
//

import UIKit

// Тип задачи
enum TaskPriority {
    // текущая
    case normal
    // важная
    case important
}

// Состояние задачи
enum TaskStatus {
    // запланированная
    case planned
    // завершенная
    case complated
}

// Требования к ниму, описывающуему сущность "Задача"
protocol TaskProtocol {
    // название
    var title: String { get set }
    // тип
    var type: TaskPriority { get set }
    // состояние
    var status: TaskStatus { get set }
}

// Сущность "Задача"
struct Task: TaskProtocol {
    var title: String
    var type: TaskPriority
    var status: TaskStatus
}
