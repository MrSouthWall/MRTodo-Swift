//
//  AddNewTodoTableViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/18.
//

import UIKit

// reuseIdentifier 重用标识符
private let infoCell = "InfoCell"
private let detailsCell = "DetailsCell"
private let listCell = "ListCell"

class AddNewTodoTableViewController: UITableViewController {
    
    private let coreDataManager = MRCoreDataManager.shared
    private let newTodoData = NewTodoData.shared
    private let seletedFolder: Folder = Folder()

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
//        tableView.reloadData() // 目前有 Bug
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
        let context = coreDataManager.context
        
        // 取出 Folder
        var folder: Folder = Folder()
        let request = Folder.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", "good")
        if let requestFolder = try? context.fetch(request) {
            folder = requestFolder.first!
            print(folder)
        } else {
            print("从 CoreData 取出文件夹数据失败！")
        }
        
        // 存到 CoreData
        let newTodo = Todo(context: context)
        newTodo.createTime = .now
        newTodo.title = newTodoData.title
        newTodo.note = newTodoData.note
        newTodo.isDone = newTodo.isDone
        newTodo.folder = newTodoData.folder
        // 保存数据
        coreDataManager.saveContext()
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
            cell.indexPath = indexPath
            cell.textView.delegate = self
            cell.configurePlaceholder()
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
        print(indexPath)
        switch indexPath.section {
        case 0:
            break
        case 1:
            let setDetailTableViewController = SetDetailTableViewController(style: .insetGrouped)
            self.navigationController?.pushViewController(setDetailTableViewController, animated: true)
        case 2:
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
    var indexPath: IndexPath = IndexPath()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupTextView()
    }
    
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
    
    /// 设置无输入状态下的 UITextField 提示词
    func configurePlaceholder() {
        
        switch indexPath.row {
        case 0:
            textView.text = "标题"
        case 1:
            textView.text = "备注"
        default:
            textView.text = "未设置提示词"
        }
        
        textView.textColor = .lightGray
    }
    
    /// 保存文字到内存中的临时 Todo
    func saveText() {
        switch indexPath.row {
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
    
    /// 当用户开始编辑时，提示此消失
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .label
        }
        textView.becomeFirstResponder() //Optional
    }
    
    // 当输入框没有字符时，显示提示词
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "" {
            if let cell = textView.superview?.superview as? InfoCell {
                cell.configurePlaceholder()
            }
        }
    }
    
    // 使 Cell 高度自动随着文本内容的改变而改变
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let cell = textView.superview?.superview as? InfoCell {
            cell.saveText()
        }
    }
    
    
}


// MARK: - DetailsCell

class DetailsCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
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
