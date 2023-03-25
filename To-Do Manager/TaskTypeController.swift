//
//  TaskTypeController.swift
//  To-Do Manager
//
//  Created by Apple M1 on 25.03.2023.
//

import UIKit

class TaskTypeController: UITableViewController {
    
    // 1. кортеж, описывающий тип задачи
    typealias TypeCellDescription = (type: TaskPriority, title: String, description: String)
    
    // 2. коллекция доступных типов задач с их описанием
    private var taskTypesInformation: [TypeCellDescription] = [
        (type: .important, title: "Важная", description: "Такой тип задачи является наиболее приоритетным для выполнения. Все важные задачи выводятся в самом верху списка задач"),
        (type: .normal, title: "Обычная", description: "Задача с обычным приоритетом")
    ]
    
    // 3. выбранный приоритет
    var selectedType: TaskPriority = .normal

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. получение значение типа UINib, соответствующее xib-файлу кастомной ячейки
        let cellTypeNib = UINib(nibName: "TaskTypeCell", bundle: nil)
        // 2. регистрация кастомной ячейки в табличном представлении
        tableView.register(cellTypeNib, forCellReuseIdentifier: "TaskTypeCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskTypesInformation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1. получение переиспользуемой кастомной ячейки по ее идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTypeCell", for: indexPath) as! TaskTypeCell
        
        // 2. получаем текущий элемент, информация о котором должна быть выведена в строке
        let typeDescription = taskTypesInformation[indexPath.row]
        
        // 3. заполняем ячейку данными
        cell.typeTitle.text = typeDescription.title
        cell.typeDescription.text = typeDescription.description
        
        // 4. если тип является выбранными, то отмечаем галочкой
        if selectedType == typeDescription.type {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}
