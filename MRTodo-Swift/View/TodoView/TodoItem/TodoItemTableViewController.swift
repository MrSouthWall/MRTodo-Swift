//
//  TodoItemTableViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/10.
//

import UIKit

class TodoItemTableViewController: UITableViewController {
    
    let todoItemData: [(doneIcon: Bool, todoTitle: String, todoNote: String)] = [
        (true, "购买杂货", "需要购买牛奶、面包、鸡蛋、蔬菜和水果。"),
        (false, "完成项目报告", "撰写报告的总结部分，并校对所有内容，确保没有语法错误。"),
        (true, "预约牙医", "打电话预约下周二下午三点的牙医检查。"),
        (false, "健身房训练", "今天进行上半身力量训练，包含胸肌和背肌练习。"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 设置导航栏
        self.navigationItem.title = "Think And Dreams"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
    }
    
    /// 设置 Todo 文件夹列表 TableView
    private func setupTableView() {
        self.tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoItemData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoItemTableViewCell

        // Configure the cell...

        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: todoItemData[indexPath.row].doneIcon ? "circle" : "checkmark.circle")
        content.text = todoItemData[indexPath.row].todoTitle
        content.secondaryText = todoItemData[indexPath.row].todoNote
        content.secondaryTextProperties.color = .gray
        cell.contentConfiguration = content
        
//        for i in indexPath {
//            cell.configure(doneIcon: todoItemData[i].doneIcon, todoTitle: todoItemData[i].todoTitle, todoNote: todoItemData[i].todoNote)
//        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

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
