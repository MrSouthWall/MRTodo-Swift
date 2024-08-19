//
//  SelectFolderTableViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/18.
//

import UIKit

private let reuseIdentifier = "Cell"

class SelectFolderTableViewController: UITableViewController {
    
    private let coreDataManager = MRCoreDataManager.shared
    private let newTodoData = NewTodoData.shared
    private var folderData: [Folder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.title = "待办文件夹"
        
        let context = coreDataManager.context
        let request = Folder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "orderId", ascending: true)]
        if let folderData = try? context.fetch(request) {
            self.folderData = folderData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
        }
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return folderData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...
        var content = cell.defaultContentConfiguration()
        let icon = folderData[indexPath.row].icon!
        content.image = UIImage(systemName: icon)
        content.text = folderData[indexPath.row].name!
        cell.contentConfiguration = content
        // Cell 右侧的 CheckMark
        if newTodoData.folder == folderData[indexPath.row] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
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
    
    
    // MARK: - Table view Degelate
    
    /// 设置 Header 视图
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: tableView.rectForHeader(inSection: 0))
        // 我的列表标题
        let titleLabel = UILabel(frame: headerView.bounds)
        titleLabel.text = "iCloud"
        titleLabel.textColor = .label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: headerView.bounds.height),
        ])
        return headerView
    }
    
    /// 设置 Header 行高
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    /// 点击 Cell 执行函数，将文件夹赋值给新待办的关联文件夹
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 设定文件夹为用户当前选择
        newTodoData.folder = folderData[indexPath.row]
        tableView.reloadData() // 刷新视图以更新 Cell 右侧的 CheckMark
        self.navigationController?.popViewController(animated: true)
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
