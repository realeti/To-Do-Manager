//
//  TaskEditController.swift
//  To-Do Manager
//
//  Created by Apple M1 on 25.03.2023.
//

import UIKit

class TaskEditController: UITableViewController {

    // параметры задачи
    var taskText: String = ""
    var taskType: TaskPriority = .normal
    var taskStatus: TaskStatus = .planned
    
    @IBOutlet var taskTitle: UITextField!
    @IBOutlet var taskTypeLabel: UILabel!
    
    // название типов задач
    private var taskTitles: [TaskPriority: String] = [
        .important: "Важная",
        .normal: "Обычная"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // обновление текстового поля с названием задачи
        taskTitle?.text = taskText
        // обновление метки в соответствии с текущим типом
        taskTypeLabel?.text = taskTitles[taskType]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

}
