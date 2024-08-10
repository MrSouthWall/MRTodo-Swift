//
//  TodoTableViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/10.
//

import UIKit

class TodoTableViewController: UITableViewController {
    
    /**
     通过 UIScreen.main.bounds 获取屏幕尺寸的方式，在 iOS 16 以上的版本中已被弃用。
     苹果官方推荐使用 view.window.windowScene.screen。
     但是这里有个问题，实际无法获取到，因为在需要获取屏幕尺寸的时候，视图层级还未完全建立。
     所以只能通过从外部传递一个值进来，曲线救国解决问题。
     */
    let screenSize: CGRect
    
    init(screenSize: CGRect, style: UITableView.Style) {
        self.screenSize = screenSize
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Todo 列表文件夹数据
    var folderData = [
        "Don't Ask! Just Do It!",
        "Think And Dreams",
        "Work",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 设置导航栏
        self.navigationItem.title = "待办事项"
        
        // 设置视图
        setupTableView()
        setupTableHeaderView()
        setupAddNewTodoButton()
    }
    
    /// 设置 Todo 文件夹列表 TableView
    private func setupTableView() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    /// 设置 Todo 文件夹列表 HeaderView
    private func setupTableHeaderView() {
        print(UIScreen.main)
        let width = screenSize.width
        let height = 220.0
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (width - 60) / 2, height: (height - 60) / 2)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let todoFolderHeaderCollectionView = TodoFolderHeaderCollectionView(frame: CGRect(x: 0, y: 0, width: width, height: height), collectionViewLayout: layout)
        self.tableView.tableHeaderView = todoFolderHeaderCollectionView
    }
    
    /// 设置新增待办按钮
    private func setupAddNewTodoButton() {
        let diameter = 70.0 // 设置圆的直径
        let cornerRadius = diameter / 2.0 // 设置圆角，如果按钮是圆形，则设置为直径的一半
        // 创建悬浮按钮
        let addNewTodoButton = UIButton(type: .system)
        addNewTodoButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addNewTodoButton.tintColor = .systemBackground
        addNewTodoButton.backgroundColor = .accent
        addNewTodoButton.applyCornerRadius(cornerRadius: cornerRadius, masksToBounds: false)
        addNewTodoButton.applyShadow()
        addNewTodoButton.translatesAutoresizingMaskIntoConstraints = false
        // 将按钮添加到主视图中
        self.view.addSubview(addNewTodoButton)
        // 设置按钮的位置
        NSLayoutConstraint.activate([
            addNewTodoButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addNewTodoButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addNewTodoButton.widthAnchor.constraint(equalToConstant: diameter),
            addNewTodoButton.heightAnchor.constraint(equalToConstant: diameter),
        ])
        // 配置按钮点击事件
        addNewTodoButton.addTarget(self, action: #selector(popupToAddNewTodo), for: .touchUpInside)
    }
    
    /// 弹出添加新 Todo 视图
    @objc private func popupToAddNewTodo() {
        // 创建要弹出的视图控制器
        let addTodoViewController = AddTodoViewController()
        // 创建导航栏
        let addTodoNavigationController = UINavigationController(rootViewController: addTodoViewController)
        // 设置弹出方式
        addTodoNavigationController.modalPresentationStyle = .pageSheet
        // 弹出视图控制器
        self.present(addTodoNavigationController, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    /// Header 的个数
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    /// 行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return folderData.count
    }
    
    /// 设置 Todo 文件夹列表的 Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: "star")
        content.text = folderData[indexPath.row]
        cell.contentConfiguration = content

        return cell
    }
    
    /// Header 的高度
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    /// 设置 Header View
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: tableView.rectForHeader(inSection: 0))
        let titleLabel = UILabel(frame: headerView.bounds)
        titleLabel.text = "我的列表"
        titleLabel.textColor = .label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        headerView.addSubview(titleLabel)
        return headerView
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
    
    /// 选中行
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row \(indexPath.row)")
        let todoTableViewController = TodoItemTableViewController(style: .plain)
        self.navigationController?.pushViewController(todoTableViewController, animated: true)
    }
    
    /// 行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
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
