//
//  SetDetailTableViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/18.
//

/* 使用 SwiftUI 编写的详情页视图，此文件弃用
import UIKit

private let flagCell = "FlagCell"
private let datePickerCell = "DatePickerCell"
//private let prioritySelectionCell = "PrioritySelectionCell"

class SetDetailTableViewController: UITableViewController {
    
    private let newTodoData = NewTodoData.shared
    private var cellDataSource: [[String]] = [
        ["StartTimeCell", "EndTimeCell"],
        ["TagsCell"],
        ["FlagCell"],
        ["Priority"],
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: flagCell)
        self.tableView.register(DatePickerCell.self, forCellReuseIdentifier: datePickerCell)
//        self.tableView.register(PrioritySelectionCell.self, forCellReuseIdentifier: prioritySelectionCell)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return cellDataSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellDataSource[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        let cellType = cellDataSource[indexPath.section][indexPath.row]
        switch cellType {
        case "StartTimeCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(systemName: "calendar")
            content.text = "开始日期"
            cell.contentConfiguration = content
            let startTimeSwitch = UISwitch()
            startTimeSwitch.addTarget(self, action: #selector(startTimeSwitchChanged(_:)), for: .valueChanged)
            cell.accessoryView = startTimeSwitch
            return cell
        case "EndTimeCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(systemName: "calendar")
            content.text = "结束日期"
            cell.contentConfiguration = content
            let startTimeSwitch = UISwitch()
            startTimeSwitch.addTarget(self, action: #selector(endTimeSwitchChanged(_:)), for: .valueChanged)
            cell.accessoryView = startTimeSwitch
            return cell
        case "DatePicker":
            let cell = tableView.dequeueReusableCell(withIdentifier: datePickerCell, for: indexPath) as! DatePickerCell
            return cell
        case "TagsCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(systemName: "tag.fill")
            content.text = "标签"
            cell.contentConfiguration = content
            cell.accessoryType = .disclosureIndicator
            return cell
        case "FlagCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: flagCell, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(systemName: "flag.fill")
            content.text = "旗帜"
            cell.contentConfiguration = content
            let flagSwitch = UISwitch()
            flagSwitch.addTarget(self, action: #selector(flagSwitchChanged(_:)), for: .valueChanged)
            cell.accessoryView = flagSwitch
            return cell
        case "Priority":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(systemName: "star")
            content.text = "优先级"
            cell.contentConfiguration = content
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            return cell
        }
    }
    
    /// 当 startTimeSwitch 切换时，在 TableView 中插入日期选择器
    @objc func startTimeSwitchChanged(_ sender: UISwitch) {
        let indexPath = IndexPath(row: 1, section: 0) // 插入的行位置
        tableView.beginUpdates()
        if sender.isOn {
            // 插入新行
            cellDataSource[0].insert("DatePicker", at: indexPath.row)
            tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            // 删除新行
            cellDataSource[0].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    /// 当 endTimeSwitch 切换时，在 TableView 中插入日期选择器
    @objc func endTimeSwitchChanged(_ sender: UISwitch) {
        let addPath = IndexPath(row: cellDataSource[0].count, section: 0) // 插入的行位置
        let removePath = IndexPath(row: cellDataSource[0].count - 1, section: 0) // 删除的行位置
        tableView.beginUpdates()
        if sender.isOn {
            // 插入新行
            cellDataSource[0].insert("DatePicker", at: addPath.row)
            tableView.insertRows(at: [addPath], with: .automatic)
        } else {
            // 删除新行
            cellDataSource[0].remove(at: removePath.row)
            tableView.deleteRows(at: [removePath], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    /// 当 FlagSwitch 切换时，改变 Todo 的 Flag 值
    @objc func flagSwitchChanged(_ sender: UISwitch) {
        newTodoData.flag = sender.isOn
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
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = cellDataSource[indexPath.section][indexPath.row]
        print(cellType)
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


// MARK: - DatePickerCell

class DatePickerCell: UITableViewCell {
    private let datePicker: UIDatePicker = UIDatePicker()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            datePicker.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            datePicker.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - PrioritySelectionCell

//class PrioritySelectionCell: UITableViewCell {
//    private let button: UIButton = UIButton()
//    private let label: UILabel = UILabel()
//    private let icon: UIImageView = UIImageView()
//    private let selectedLabel: UILabel = UILabel()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        icon.image = UIImage(systemName: "star")
//        icon.backgroundColor = .red
//        icon.contentMode = .scaleAspectFit
//        icon.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addSubview(icon)
//        NSLayoutConstraint.activate([
//            icon.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
//            icon.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
//            icon.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
//            icon.widthAnchor.constraint(equalToConstant: 20),
//        ])
//        
//        selectedLabel.text = "无"
//        selectedLabel.backgroundColor = .blue
//        selectedLabel.font = .preferredFont(forTextStyle: .body)
//        selectedLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addSubview(selectedLabel)
//        NSLayoutConstraint.activate([
//            selectedLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
//            selectedLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
//            selectedLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
//        ])
//        
//        
//        label.text = "优先级"
//        label.backgroundColor = .blue
//        label.font = .preferredFont(forTextStyle: .body)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addSubview(label)
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
//            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
//            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 20),
//            label.trailingAnchor.constraint(equalTo: selectedLabel.leadingAnchor, constant: -20),
//        ])
//        
//        let menu = UIMenu(children: [
//            UIAction(title: "无", handler: { _ in
//                print("无")
//            }),
//            UIAction(title: "低", handler: { _ in
//                print("低")
//            }),
//            UIAction(title: "中", handler: { _ in
//                print("中")
//            }),
//            UIAction(title: "高", handler: { _ in
//                print("高")
//            }),
//        ])
//        button.setTitle("hello", for: .normal)
//        button.menu = menu
//        button.showsMenuAsPrimaryAction = true
//        button.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addSubview(button)
//        NSLayoutConstraint.activate([
//            button.topAnchor.constraint(equalTo: self.contentView.topAnchor),
//            button.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
//            button.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
//            button.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
//        ])
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
 */
