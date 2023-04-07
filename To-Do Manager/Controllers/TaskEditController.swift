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
    @IBOutlet var taskTypeTitle: UILabel!
    @IBOutlet var taskStatusTitle: UILabel!
    @IBOutlet var taskStatusSwitch: UISwitch!
    
    // свойство для передачи замыкания в TaskListController
    var doAfterEdit: ((String, TaskPriority, TaskStatus) -> Void)?
    
    // название типов задач
    private var taskTitles: [TaskPriority:String] = [
        .important: TaskString.importantTasks.localazied,
        .normal: TaskString.normalTasks.localazied
    ]
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        // получаем актуальные значения
        let title = taskTitle?.text ?? ""
        let type = taskType
        let status: TaskStatus = taskStatusSwitch.isOn ? .complated : .planned
        
        // вызываем обработчик
        doAfterEdit?(title, type, status)
        
        // возвращаемся к предыдущему экрану
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // обновление текстового поля с названием задачи
        taskTitle?.text = taskText
        // обновление метки в соответствии с текущим типом
        taskTypeLabel?.text = taskTitles[taskType]
        // обновляем статус задачи
        if taskStatus == .complated {
            taskStatusSwitch.isOn = true
        }
        
        navigationItem.rightBarButtonItem?.title = TaskString.saveButton.localazied
        taskTypeTitle.text = TaskString.taskTypeTitle.localazied
        taskStatusTitle.text = TaskString.taskStatusTitle.localazied
        taskTitle.placeholder = TaskString.taskEditPlaceholder.localazied
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskTypeScreen" {
            // ссылка на контроллер назначения
            let destination = segue.destination as! TaskTypeController
            // передача выбранного типа
            destination.selectedType = taskType
            // передача обработчика выбора типа
            destination.doAfterTypeSelected = { [unowned self] selectedType in
                taskType = selectedType
                // обновляем метку с текущим типом
                taskTypeLabel?.text = taskTitles[taskType]
            }
        }
    }

}
