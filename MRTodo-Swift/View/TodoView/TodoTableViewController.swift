//
//  TodoTableViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/10.
//

import UIKit

private let reuseIdentifier = "Cell"

class TodoTableViewController: UITableViewController {
    
    /**
     通过 UIScreen.main.bounds 获取屏幕尺寸的方式，在 iOS 16 以上的版本中已被弃用。
     苹果官方推荐使用 view.window.windowScene.screen。
     但是这里有个问题，实际无法获取到，因为在需要获取屏幕尺寸的时候，视图层级还未完全建立。
     所以只能通过从外部传递一个值进来，曲线救国解决问题。
     */
    private let screenSize: CGRect
    
    private let iconDiameter = 34.0
    
    private let coreDataManager = MRCoreDataManager.shared
    private let folderIconData = NewFolderData.shared
    private let newTodoData = NewTodoData.shared
    
    /// Todo 列表文件夹数据
    private var folderData: [Folder] = []
    
    var topEntries: [(icon: FolderIcon, name: String, count: String)] = []
    
    init(screenSize: CGRect, style: UITableView.Style) {
        self.screenSize = screenSize
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 设置导航栏
        self.navigationItem.title = "待办事项"
        
        self.tableView.separatorInset.left = iconDiameter + 30
        
        let todayCount = String(requestTodayTodoData().count)
        let timeLineCount = String(requestTimelineTodoData().count)
        let allCount = String(requestAllTodoData().count)
        let flagCount = String(requestFlagTodoData().count)
        
        // 置顶的条目信息
        topEntries = [
            (FolderIcon(diameter: iconDiameter, iconName: "star.circle.fill", hexColor: "007AFF", isShoeShadow: false), "今天", todayCount),
            (FolderIcon(diameter: iconDiameter, iconName: "calendar", hexColor: "FF3B31", isShoeShadow: false), "计划", timeLineCount),
            (FolderIcon(diameter: iconDiameter, iconName: "archivebox", hexColor: "000000", isShoeShadow: false), "所有", allCount),
            (FolderIcon(diameter: iconDiameter, iconName: "flag.fill", hexColor: "FF9403", isShoeShadow: false), "旗帜", flagCount),
        ]

        fetchRequestData()
        // 设置视图
        setupTableView()
        setupTableHeaderView()
        setupAddNewTodoButton()
    }
    
    /// 从 CoreData 取出数据
    private func fetchRequestData() {
        let context = coreDataManager.context
        let request = Folder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "orderId", ascending: true)]
        if let folderData = try? context.fetch(request) {
            self.folderData = folderData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
        }
    }
    
    /// 设置 Todo 文件夹列表 TableView
    private func setupTableView() {
        self.tableView.register(FolderTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    /// 设置 Todo 文件夹列表 HeaderView
    private func setupTableHeaderView() {
        let width = screenSize.width
        let height = 220.0
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (width - 60) / 2, height: (height - 60) / 2)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let todoFolderHeaderCollectionView = TodoFolderHeaderCollectionView(frame: CGRect(x: 0, y: 0, width: width, height: height), collectionViewLayout: layout)
        todoFolderHeaderCollectionView.dataSource = self
        todoFolderHeaderCollectionView.delegate = self
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
    
    // MARK: - 获取 CoreData 数据
    
    /// 获取今天的 Todo 列表
    func requestTodayTodoData() -> [Todo] {
        // 筛选今天的数据
        let context = coreDataManager.context
        let request = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "startTime == %@", Date.now as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "endTime", ascending: true), NSSortDescriptor(key: "startTime", ascending: true)]
        if let todoData = try? context.fetch(request) {
            return todoData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
            return []
        }
    }
    
    /// 获取时间线的 Todo 列表
    func requestTimelineTodoData() -> [Todo] {
        // 筛选时间线的 Todo 数据
        return []
    }
    
    /// 获取所有的 Todo 列表
    func requestAllTodoData() -> [Todo] {
        let context = coreDataManager.context
        let request = Todo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createTime", ascending: true), NSSortDescriptor(key: "orderId", ascending: true)]
        if let todoData = try? context.fetch(request) {
            return todoData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
            return []
        }
    }
    
    /// 获取旗帜的 Todo 列表
    func requestFlagTodoData() -> [Todo] {
        let context = coreDataManager.context
        let request = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "flag == true")
        request.sortDescriptors = [NSSortDescriptor(key: "createTime", ascending: true), NSSortDescriptor(key: "orderId", ascending: true)]
        if let todoData = try? context.fetch(request) {
            return todoData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
            return []
        }
    }
    
    /// 获取选定文件夹的 Todo 列表
    func requestTodoDataFilteredByFolder(folderName: String) -> [Todo] {
        let context = coreDataManager.context
        let request = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "folder.name == %@", folderName)
        request.sortDescriptors = [NSSortDescriptor(key: "orderId", ascending: true)]
        if let todoData = try? context.fetch(request) {
            return todoData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
            return []
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
            self?.fetchRequestData()
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
        todoTableViewController.setTodoData(todoData: requestTodoDataFilteredByFolder(folderName: currentFolderName ?? ""))
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
