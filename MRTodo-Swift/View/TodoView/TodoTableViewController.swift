//
//  TodoTableViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/10.
//

import UIKit

private let reuseIdentifier = "Cell"

class TodoTableViewController: UITableViewController {
    
    // 单例对象
    private let coreDataManager = MRCoreDataManager.shared
    private let folderIconData = NewFolderData.shared
    private let newTodoData = NewTodoData.shared
    
    /**
     通过 UIScreen.main.bounds 获取屏幕尺寸的方式，在 iOS 16 以上的版本中已被弃用。
     苹果官方推荐使用 view.window.windowScene.screen。
     但是这里有个问题，实际无法获取到，因为在需要获取屏幕尺寸的时候，视图层级还未完全建立。
     所以只能通过从外部传递一个值进来，曲线救国解决问题。
     */
    private let screenSize: CGRect
    
    // 常量
    private let iconDiameter = 34.0
    
    /// Todo 列表文件夹数据
    private var folderData: [Folder] = Folder.requestWithOrderId()
    
    private var todoHeaderCollectionView: UICollectionView?
    /// 置顶分类信息
    private var topEntries: [(icon: FolderIcon, name: String, count: String)] {
        return [
            (FolderIcon(diameter: iconDiameter, iconName: "star.circle.fill", hexColor: "007AFF", isShoeShadow: false), "今天", String(Todo.requestWithToday().count)),
            (FolderIcon(diameter: iconDiameter, iconName: "calendar", hexColor: "FF3B31", isShoeShadow: false), "计划", String(Todo.requestWithTimeline().count)),
            (FolderIcon(diameter: iconDiameter, iconName: "archivebox", hexColor: "000000", isShoeShadow: false), "所有", String(Todo.requestWithAllTodo().count)),
            (FolderIcon(diameter: iconDiameter, iconName: "flag.fill", hexColor: "FF9403", isShoeShadow: false), "旗帜", String(Todo.requestWithFlag().count)),
        ]
    }
    
    init(screenSize: CGRect, style: UITableView.Style) {
        self.screenSize = screenSize
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航栏
        setupNavigation()
        // 设置头部置顶的分类选项卡
        setupHeaderView()
        // 设置文件夹列表
        setupTableView()
        // 设置右下角悬浮按钮
        setupAddNewTodoButton()
        
        // 监听 Core Data 保存的通知
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }
    
    @objc func contextDidSave(_ notification: Notification) {
        // 当 Core Data 数据有更新时执行的函数
        todoHeaderCollectionView?.reloadData()
    }
    
    /// 配置导航栏
    private func setupNavigation() {
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 设置导航栏
        self.navigationItem.title = "待办事项"
    }
    
    /// 设置 Todo 文件夹列表 HeaderView
    private func setupHeaderView() {
        let width = screenSize.width
        let height = 220.0
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (width - 60) / 2, height: (height - 60) / 2)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        todoHeaderCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: width, height: height), collectionViewLayout: layout)
        todoHeaderCollectionView?.dataSource = self
        todoHeaderCollectionView?.delegate = self
        todoHeaderCollectionView?.register(TodoHeaderCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        todoHeaderCollectionView?.backgroundColor = .systemGroupedBackground
        self.tableView.tableHeaderView = todoHeaderCollectionView
    }
    
    /// 设置 Todo 文件夹列表 TableView
    private func setupTableView() {
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        
        self.tableView.separatorInset.left = iconDiameter + 30
        self.tableView.register(FolderTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
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
        // 重置临时 Todo 的数据
        newTodoData.resetToDefault()
        // 创建要弹出的视图控制器
        let addNewTodoViewController = AddNewTodoTableViewController(style: .insetGrouped)
        // 创建导航栏
        let addNewTodoNavigationController = UINavigationController(rootViewController: addNewTodoViewController)
        // 设置弹出方式
        addNewTodoNavigationController.modalPresentationStyle = .pageSheet
        // 弹出视图控制器
        self.present(addNewTodoNavigationController, animated: true, completion: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        // 开始动画
        UIView.animate(.easeInOut) {
            if self.tableView.isEditing {
                self.tableView.separatorInset.left = self.iconDiameter + 70
            } else {
                self.tableView.separatorInset.left = self.iconDiameter + 30
            }
            
            // 强制刷新布局，以便分隔符的改变被动画化
            self.tableView.layoutIfNeeded()
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FolderTableViewCell

        // Configure the cell...
        
        // 给每条数据赋值 orderId
        folderData[indexPath.row].orderId = Int16(indexPath.row)
        coreDataManager.saveContext()
        
        let icon = FolderIcon(diameter: iconDiameter, iconName: folderData[indexPath.row].icon ?? "star", hexColor: folderData[indexPath.row].color ?? "#000000", isShoeShadow: false)
        cell.configureCell(folderIcon: icon, folderName: folderData[indexPath.row].name ?? "空文件夹")

        return cell
    }
    
    /// 设置 Header View
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: tableView.rectForHeader(inSection: 0))
        // 我的列表标题
        let titleLabel = UILabel(frame: headerView.bounds)
        titleLabel.text = "我的列表"
        titleLabel.textColor = .label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: headerView.bounds.height),
        ])
        // 新建文件夹按钮
        let addNewFolderButton = UIButton(type: .system)
        addNewFolderButton.frame = headerView.bounds
        addNewFolderButton.setImage(UIImage(systemName: "folder.badge.plus"), for: .normal)
        addNewFolderButton.tintColor = .accent
        addNewFolderButton.addTarget(self, action: #selector(popupToAddNewFolder), for: .touchUpInside)
        addNewFolderButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(addNewFolderButton)
        NSLayoutConstraint.activate([
            addNewFolderButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            addNewFolderButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            addNewFolderButton.heightAnchor.constraint(equalToConstant: headerView.bounds.height),
            addNewFolderButton.widthAnchor.constraint(equalToConstant: headerView.bounds.height),
        ])
        return headerView
    }
    
    /// 弹出新建文件夹窗口
    @objc func popupToAddNewFolder() {
        // 初始化文件夹数据
        folderIconData.resetToDefault()
        // 创建要弹出的视图控制器
        let addNewFolderTableViewController = AddNewFolderTableViewController(style: .insetGrouped)
        // 一个闭包，用于刷新视图
        addNewFolderTableViewController.updateView = { [weak self] in
            self?.folderData = Folder.requestWithOrderId()
            // 两种刷新视图的方式，第一种是在最后插入一行
            self?.tableView.insertRows(at: [IndexPath(row: (self?.folderData.count)! - 1, section: 0)], with: .automatic)
            // 第二种是直接整个视图刷新，为了节省性能，我们选择第一种方式
            // self?.tableView.reloadData()
        }
        // 创建导航栏
        let addNewFolderTableNavigationController = UINavigationController(rootViewController: addNewFolderTableViewController)
        // 设置弹出方式
        addNewFolderTableNavigationController.modalPresentationStyle = .pageSheet
        // 弹出视图控制器
        self.present(addNewFolderTableNavigationController, animated: true, completion: nil)
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
            coreDataManager.context.delete(folderData[indexPath.row])
            folderData.remove(at: indexPath.row)
            // 最后从表格视图中删除行，更新 UI
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // 提供排序功能
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let folderToRemove = folderData[fromIndexPath.row] // 暂存被替换的数据
        folderData.remove(at: fromIndexPath.row) // 移动数据
        folderData.insert(folderToRemove, at: to.row) // 把暂存的数据插入回来
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
    
    /// Header 的高度
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    /// 点击进入文件夹内的 Todo 列表
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoTableViewController = TodoItemTableViewController(style: .plain)
        todoTableViewController.todoFilteringMode = .folder
        let currentFolderName = folderData[indexPath.row].name
        todoTableViewController.currentFolderName = currentFolderName
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


// MARK: - UICollectionView DataSource、Delegate

extension TodoTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // UICollectionViewDataSource
    
    /// CollectionView 标题数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    /// 设置 Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TodoHeaderCollectionViewCell
        
        cell.backgroundColor = .cellBackground
        cell.applyCornerRadius()
        let i = indexPath.row
        cell.configure(folderIcon: topEntries[i].icon, folderName: topEntries[i].name, itemNumber: topEntries[i].count)
        
        return cell
    }
    
    
    // UICollectionViewDelegate
    
    /// 点击 Cell 跳转到 Todo 列表页
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let todoTableViewController = TodoItemTableViewController(style: .plain)
            todoTableViewController.todoFilteringMode = .today
            self.navigationController?.pushViewController(todoTableViewController, animated: true)
        case 1:
            let todoTableViewController = TodoItemTableViewController(style: .plain)
            todoTableViewController.todoFilteringMode = .timeline
            self.navigationController?.pushViewController(todoTableViewController, animated: true)
        case 2:
            let todoTableViewController = TodoItemTableViewController(style: .plain)
            todoTableViewController.todoFilteringMode = .all
            self.navigationController?.pushViewController(todoTableViewController, animated: true)
        case 3:
            let todoTableViewController = TodoItemTableViewController(style: .plain)
            todoTableViewController.todoFilteringMode = .flag
            self.navigationController?.pushViewController(todoTableViewController, animated: true)
        default:
            break
        }
    }
    
    /// 点击时执行
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.3) {
                cell.backgroundColor = .lightGray
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    /// 松开时执行
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.5) {
                cell.backgroundColor = .cellBackground
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
}
