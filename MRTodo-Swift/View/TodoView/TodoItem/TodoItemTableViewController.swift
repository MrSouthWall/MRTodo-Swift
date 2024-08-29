//
//  TodoItemTableViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/10.
//

import UIKit

/// Todo 列表页的筛选模式，特制的模式有特制的 UI
enum TodoFilteringMode {
    case today
    case timeline
    case all
    case flag
    case folder
}

private let reuseIdentifier = "Cell"

class TodoItemTableViewController: UITableViewController {
    
    /// Todo 列表的筛选模式
    var todoFilteringMode: TodoFilteringMode = .all
    var currentFolderName: String?
    
    private let coreDataManager = MRCoreDataManager.shared
    private var todoData: [Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        switch todoFilteringMode {
        case .today:
            self.navigationItem.title = "今天"
        case .timeline:
            self.navigationItem.title = "时间轴"
        case .all:
            self.navigationItem.title = "所有"
        case .flag:
            self.navigationItem.title = "旗帜"
        case .folder:
            self.navigationItem.title = currentFolderName
        }
        // 设置导航栏
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    /// 设置数据
    func setTodoData(todoData: [Todo]) {
        self.todoData = todoData
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TodoItemTableViewCell

        // Configure the cell...
        todoData[indexPath.row].orderId = Int16(indexPath.row)
        coreDataManager.saveContext()
        let currentCellTodoData = todoData[indexPath.row]
        let isDone = currentCellTodoData.isDone
        let title = currentCellTodoData.title!
        let note = currentCellTodoData.note ?? ""
        cell.configure(doneIcon: isDone, todoTitle: title, todoNote: note)
        // 传递闭包，刷新视图
        cell.buttonAction = {
            currentCellTodoData.isDone.toggle()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    // 提供删除功能
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            // 先删除 CoreData 中的数据，再删除内存中的数据
            // 因为我们是从内存中取出对象，如果先删内存，那么就没有办法告诉 CoreData 删除哪个对象了
            coreDataManager.context.delete(todoData[indexPath.row])
            todoData.remove(at: indexPath.row)
            // 最后从表格视图中删除行，更新 UI
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // 提供排序功能
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let todoToRemove = todoData[fromIndexPath.row] // 暂存被替换的数据
        todoData.remove(at: fromIndexPath.row) // 移动数据
        todoData.insert(todoToRemove, at: to.row) // 把暂存的数据插入回来
        tableView.reloadData() // 重新加载数据，以重新分配 orderId
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    // MARK: - UITableViewDelegate
    
    /// 行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
