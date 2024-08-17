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
    
    let folderIconData = FolderIconData.shared
    
    init(screenSize: CGRect, style: UITableView.Style) {
        self.screenSize = screenSize
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Todo 列表文件夹数据
    var folderData: [Folder] {
        let coreDataManager = MRCoreDataManager.shared
        let context = coreDataManager.context
        if let folderData = try? context.fetch(Folder.fetchRequest()) {
            return folderData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
            return []
        }
    }

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
        let addNewTodoViewController = AddNewTodoViewController()
        // 创建导航栏
        let addNewTodoNavigationController = UINavigationController(rootViewController: addNewTodoViewController)
        // 设置弹出方式
        addNewTodoNavigationController.modalPresentationStyle = .pageSheet
        // 弹出视图控制器
        self.present(addNewTodoNavigationController, animated: true, completion: nil)
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
        let icon = folderData[indexPath.row].icon!
        content.image = UIImage(systemName: icon)
        content.text = folderData[indexPath.row].name!
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator

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
        addNewFolderTableViewController.onSaveData = { [weak self] in
            self?.tableView.reloadData()
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
    
    /// Header 的高度
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    /// 选中行
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
