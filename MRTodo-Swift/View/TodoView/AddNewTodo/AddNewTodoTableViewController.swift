//
//  AddNewTodoTableViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/18.
//

import UIKit
import SwiftUI

// reuseIdentifier 重用标识符
private let infoCell = "InfoCell"
private let detailsCell = "DetailsCell"
private let listCell = "ListCell"

class AddNewTodoTableViewController: UITableViewController {
    
    private let coreDataManager = MRCoreDataManager.shared
    private let newTodoData = NewTodoData.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        setupNavigationBar()
        setupTableView()
        
        // 添加通知监听，当 .newTodoFolderDataDidChange 通知触发时，执行 refreshView 函数
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: .newTodoFolderDataDidChange, object: nil)
        
    }
    
    // 单对象被释放时，移除观察者，以避免潜在的内存泄漏问题
    deinit {
        NotificationCenter.default.removeObserver(self, name: .newTodoFolderDataDidChange, object: nil)
    }
    
    /// 更新数据
    @objc func refreshView() {
        tableView.reloadData()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        self.navigationItem.title = "添加待办"
        // 完成按钮
        let doneButton = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(doneButton))
        self.navigationItem.rightBarButtonItem = doneButton
        // 取消按钮
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    /// 设置 TableView
    private func setupTableView() {
        self.tableView.estimatedRowHeight = 100 // 预估行高
        self.tableView.rowHeight = UITableView.automaticDimension // 自动计算行高
        self.tableView.register(InfoCell.self, forCellReuseIdentifier: infoCell)
        self.tableView.register(DetailsCell.self, forCellReuseIdentifier: detailsCell)
        self.tableView.register(ListCell.self, forCellReuseIdentifier: listCell)
    }
    
    /// 完成按钮执行函数
    @objc private func doneButton() {
        view.endEditing(true) // 关闭键盘
        newTodoData.saveToCoreData()
        self.dismiss(animated: true)
    }
    
    /// 取消按钮执行函数
    @objc private func cancelButton() {
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
        switch section {
        case 0:
            return 2
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCell, for: indexPath) as! InfoCell
            // 配置无输入状态下的提示词
            cell.cellRow = indexPath.row // 传入行数，区分标题和备注
            cell.textView.delegate = self // 在外部设置代理，主要为了用于刷新行高
            cell.loadData() // 当视图刷新时重新从临时 newTodoData 中加载数据，并且用于设置占位符
            cell.updatePlaceholderVisibility() // 刷新占位符
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailsCell, for: indexPath) as! DetailsCell
            var content = UIListContentConfiguration.cell()
            content.text = "详细信息"
            cell.contentConfiguration = content
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: listCell, for: indexPath) as! ListCell
            var content = UIListContentConfiguration.cell()
            content.text = newTodoData.folder?.name
            content.image = UIImage(systemName: newTodoData.folder?.icon ?? "exclamationmark.circle")
            cell.contentConfiguration = content
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
    
    
    //MARK: - Table view Delegate
    
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
    
    /// 点击进入文件夹内的 Todo 列表
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            view.endEditing(true) // 关闭键盘
            let setDetailView = SetDetailView()
            let hostingController = UIHostingController(rootView: setDetailView)
            hostingController.navigationItem.title = "详情信息"
            self.navigationController?.pushViewController(hostingController, animated: true)

        case 2:
            view.endEditing(true) // 关闭键盘
            let selectFolderTableViewController = SelectFolderTableViewController(style: .plain)
            self.navigationController?.pushViewController(selectFolderTableViewController, animated: true)
        default:
            break
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


// MARK: - InfoCell

class InfoCell: UITableViewCell {
    
    private let newTodoData = NewTodoData.shared
    let textView: UITextView = UITextView()
    let placeholderLabel = UILabel()
    var cellRow = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none

        setupTextView()
        setupPlaceholderLabel()
    }
    
    /// 设置文本输入框
    private func setupTextView() {
        textView.backgroundColor = .clear
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        self.contentView.addSubview(textView)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            textView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            textView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
        ])
    }
    
    /// 设置占位符
    private func setupPlaceholderLabel() {
        placeholderLabel.font = UIFont.preferredFont(forTextStyle: .body)
        placeholderLabel.textColor = .gray
        self.contentView.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            placeholderLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            placeholderLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 25),
            placeholderLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -25),
        ])
    }
    
    /// 用于设置好文件夹和设置好详细信息后，给 TextView 加载临时对象 newTodoData 中的数据，同时赋给占位符字符
    func loadData() {
        switch cellRow {
        case 0:
            textView.text = newTodoData.title
            placeholderLabel.text = "标题"
        case 1:
            textView.text = newTodoData.note
            placeholderLabel.text = "备注"
        default:
            textView.text = "?"
            placeholderLabel.text = "?"
        }
    }
    
    /// 更新占位符显示
    func updatePlaceholderVisibility() {
        if textView.text.isEmpty || textView.text == "" {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
    
    /// 保存文字到内存中的临时 Todo
    func saveText() {
        switch cellRow {
        case 0:
            newTodoData.title = textView.text
        case 1:
            newTodoData.note = textView.text
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - UITextViewDelegate

extension AddNewTodoTableViewController: UITextViewDelegate {
    
    /// 使 Cell 高度自动随着文本内容的改变而改变
    func textViewDidChange(_ textView: UITextView) {
        if let cell = textView.superview?.superview as? InfoCell {
            cell.updatePlaceholderVisibility()
            cell.saveText()
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}


// MARK: - DetailsCell

class DetailsCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - ListCell

class ListCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
