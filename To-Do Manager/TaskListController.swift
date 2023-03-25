//
//  TaskListController.swift
//  To-Do Manager
//
//  Created by Apple M1 on 13.03.2023.
//

import UIKit

class TaskListController: UITableViewController {
    
    // порядок отображения задач по их статусу
    var tasksStatusPosition: [TaskStatus] = [.planned, .complated]

    // хранилище задач
    var tasksStorage: TasksStorageProtocol = TasksStorage()
    
    // коллекция задач
    var tasks: [TaskPriority: [TaskProtocol]] = [:] {
        didSet {
            // cортировка списка задач
            for (taskGroupPriority, taskGroup) in tasks {
                tasks[taskGroupPriority] = taskGroup.sorted {task1, task2 in
                    let task1Position = tasksStatusPosition.firstIndex(of: task1.status) ?? 0
                    let task2Position = tasksStatusPosition.firstIndex(of: task2.status) ?? 0
                    
                    return task1Position < task2Position
                }
            }
        }
    }
    
    // порядок отображения секций по типам
    // индекс в массиве соответствует индексу секции в таблице
    var sectionsTypesPosition: [TaskPriority] = [.important, .normal]
    
    // свойство для передачи замыкания в TaskEditController
    var doAfterEdit: ((String, TaskPriority, TaskStatus) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // загрузка задач
        loadTasks()

        // кнопка активации режима редактирования
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    private func loadTasks() {
        // подготовка коллекции с задачами
        // будем использовать только те задачи, для которых определена секция в таблице
        sectionsTypesPosition.forEach { taskType in
            tasks[taskType] = []
        }
        
        // загрузка и разбор задач из хранилища
        tasksStorage.loadTasks().forEach { task in
            tasks[task.type]?.append(task)
        }
    }

    // MARK: - Table view data source

    // кол-во секций в таблице
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }

    // кол-во строк в определенной секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // определяем приоритет задач для текущей секции
        let taskType = sectionsTypesPosition[section]
        
        guard let currentTaskType = tasks[taskType] else {
            return 0
        }
        
        return currentTaskType.count
    }
    
    // ячейка для строки таблицы
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ячейка на основе констрейнтов
        //return getConfiguratedTaskCell_constraints(for: indexPath)
        
        // ячейка на основе стека
        return getConfiguratedCell_stack(for: indexPath)
    }
    
    // ячейка на основе ограничений
    private func getConfiguratedTaskCell_constraints(for indexPath: IndexPath) -> UITableViewCell {
        // загружаем прототип ячейки по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstraints", for: indexPath)
        // получаем данные о задаче, которую необходимо вывести в ячейке
        let taskType = sectionsTypesPosition[indexPath.section]
        
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        
        // текстовая метка символа
        let symbolLabel = cell.viewWithTag(1) as? UILabel
        // текстовая метка названия задачи
        let textLabel = cell.viewWithTag(2) as? UILabel
        
        // изменяем символ в ячейке
        symbolLabel?.text = getSymbolForTask(with: currentTask.status)
        // изменяем текст в ячейке
        textLabel?.text = currentTask.title
        
        // изменяем цвет текста и символа
        if currentTask.status == .planned {
            symbolLabel?.textColor = .black
            textLabel?.textColor = .black
        } else {
            symbolLabel?.textColor = .lightGray
            textLabel?.textColor = .lightGray
        }
        
        return cell
    }
    
    // ячейка на основе стека
    private func getConfiguratedCell_stack(for indexPath: IndexPath) -> UITableViewCell {
        // загружаем прототип ячейки по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellStack", for: indexPath) as! TaskCell
        // получаем данные о задаче, которые необходимо вывести в ячейке
        let taskType = sectionsTypesPosition[indexPath.section]
        
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        
        // изменяем текст в ячейке
        cell.title.text = currentTask.title
        // изменяем символ в ячейке
        cell.symbol.text = getSymbolForTask(with: currentTask.status)
        
        // изменяем цвет текста и символа
        if currentTask.status == .planned {
            cell.title.textColor = .black
            cell.symbol.textColor = .black
        } else if currentTask.status == .complated {
            cell.title.textColor = .lightGray
            cell.symbol.textColor = .lightGray
        }
        
        return cell
    }
    
    // возвращаем символ для соответствующего типа задачи
    private func getSymbolForTask(with status: TaskStatus) -> String {
        var resultSymbol: String
        
        if status == .planned {
            resultSymbol = "\u{25CB}"
        } else if status == .complated {
            resultSymbol = "\u{25C9}"
        } else {
            resultSymbol = ""
        }
        return resultSymbol
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        let taskType = sectionsTypesPosition[section]
        
        if taskType == .important {
            title = "Важные"
        } else if taskType == .normal {
            title = "Обычные"
        }
        
        return title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1. Определяем тип выбранной задачи
        let taskType = sectionsTypesPosition[indexPath.section]
        
        // 2. Определяем существует ли задача
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return
        }
        
        // 3. Убеждаемся что задача не выполнена
        guard tasks[taskType]![indexPath.row].status == .planned else {
            // снимаем выделение со строки
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        // 3. Отмечаем задачу как выполненную
        tasks[taskType]![indexPath.row].status = .complated
        
        // 4. Перезагружаем секцию таблицы
        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // получаем данные о задаче, которую необходимо перевести в статус "запланирована"
        let taskType = sectionsTypesPosition[indexPath.section]
        
        // проверяем, существует ли задача
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return nil
        }
        
        // проверяем, что задача имеет статус выполнена
        guard tasks[taskType]![indexPath.row].status == .complated else {
            return nil
        }
        
        // cоздаем действие для изменения статуса
        let actionSwipeInstance = UIContextualAction(style: .normal, title: "Не выполнена", handler: {_, _, _ in
            self.tasks[taskType]![indexPath.row].status = .planned
            self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        })
        
        // возвращаем настроенный обьект
        return UISwipeActionsConfiguration(actions: [actionSwipeInstance])
    }
    
    // обработка нажатия на иконку редактирования
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // удаляем задачу
        let taskType = sectionsTypesPosition[indexPath.section]
        tasks[taskType]?.remove(at: indexPath.row)
        
        // удаляем строку с табличного представления
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // ручная сортировка списка задач
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // секция из которой происходит перемещение
        let taskTypeFrom = sectionsTypesPosition[sourceIndexPath.section]
        // секция в которую происходит перемещение
        let taskTypeTo = sectionsTypesPosition[destinationIndexPath.section]
        
        // безопасно извлекаем задачу, тем самым копируем её
        guard let movedTask = tasks[taskTypeFrom]?[sourceIndexPath.row] else {
            return
        }
        
        // удаляем задачу с места, от куда она перенесена
        tasks[taskTypeFrom]!.remove(at: sourceIndexPath.row)
        // вставляем задачу на новую позицию
        tasks[taskTypeTo]!.insert(movedTask, at: destinationIndexPath.row)
        
        // если секция изменилась, изменяем тип задачи в соответствии с новой позицией
        if taskTypeFrom != taskTypeTo {
            tasks[taskTypeTo]![destinationIndexPath.row].type = taskTypeTo
        }
        
        // обновляем данные
        tableView.reloadData()
    }
}
