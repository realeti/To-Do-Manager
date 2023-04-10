//
//  TaskString.swift
//  To-Do Manager
//
//  Created by Apple M1 on 07.04.2023.
//

import Foundation

enum TaskString: String {
    case change
    case delete
    case editButton
    case doneButton
    case backButton
    case saveButton
    case notCompleted
    case importantTasks
    case normalTasks
    case importantTaskDescription
    case normalTaskDescription
    case taskTypeTitle
    case taskStatusTitle
    case taskEditPlaceholder
    case error
    
    var localazied: String {
        NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
    }
}


