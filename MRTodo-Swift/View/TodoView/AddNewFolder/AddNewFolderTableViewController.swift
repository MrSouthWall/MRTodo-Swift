//
//  AddNewFolderTableViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/12.
//

import UIKit

class AddNewFolderTableViewController: UITableViewController {
    
    let newFolderData = NewFolderData.shared
    
    let doneButton = UIBarButtonItem()
    let cancelButton = UIBarButtonItem()
    
    var updateView: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        setupNavigationBar()
        setupTableView()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        self.navigationItem.title = "新建文件夹"
        // 完成按钮
        doneButton.title = "完成"
        doneButton.style = .done
        doneButton.target = self
        doneButton.action = #selector(doneButtonAction)
        doneButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = doneButton
        // 取消按钮
        cancelButton.title = "取消"
        cancelButton.style = .plain
        cancelButton.target = self
        cancelButton.action = #selector(cancelButtonAction)
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    /// 设置 TableView
    private func setupTableView() {
        tableView.estimatedRowHeight = 200 // 预估行高
        tableView.rowHeight = UITableView.automaticDimension // 自动计算行高
        self.tableView.register(FolderNameTableViewCell.self, forCellReuseIdentifier: "FolderNameCell")
        self.tableView.register(FolderColorTableViewCell.self, forCellReuseIdentifier: "FolderColorCell")
        self.tableView.register(FolderIconTableViewCell.self, forCellReuseIdentifier: "FolderIconCell")
    }
    
    /// 完成按钮执行函数
    @objc private func doneButtonAction() {
        newFolderData.saveToCoreData()
        // 更新文件夹视图
        updateView?()
        self.dismiss(animated: true)
    }
    
    /// 取消按钮执行函数
    @objc private func cancelButtonAction() {
        // 用户点击了取消按钮
        self.dismiss(animated: true)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FolderNameCell", for: indexPath) as! FolderNameTableViewCell
            cell.isEnableDoneButton = {
                let nameTextField = self.newFolderData.name
                if nameTextField.isEmpty || nameTextField == "" {
                    self.doneButton.isEnabled = false
                } else {
                    self.doneButton.isEnabled = true
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FolderColorCell", for: indexPath) as! FolderColorTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FolderIconCell", for: indexPath) as! FolderIconTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
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
    
    
    // MARK: - Table view Delegate
    
    /// 设置 Header 视图
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    /// 设置 Header 行高
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10
        default:
            return UITableView.automaticDimension // 自动计算
        }
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
