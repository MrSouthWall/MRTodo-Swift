//
//  TodoFolderHeaderCollectionView.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/10.
//

import UIKit

private let reuseIdentifier = "Cell"

class TodoFolderHeaderCollectionView: UICollectionView {
    
    private let coreDataManager = MRCoreDataManager.shared
    
    private var todoData: [Todo] = []
    private var currentFolder: Folder?
    
    /// 初始化
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        // 设置视图
        setupCollectionView()
    }
    
    /// 设置待办事项文件夹列表的头部分类视图
    private func setupCollectionView() {
        self.backgroundColor = .systemGroupedBackground
        // 设置数据源和委托
        self.register(TodoFolderHeaderCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    /// 设置 Cell 的背景颜色
    private func setbackgroundColor(_ cell: TodoFolderHeaderCollectionViewCell) {
        if UITraitCollection.current.userInterfaceStyle == .light {
            cell.backgroundColor = .white
        } else {
            cell.backgroundColor = .secondarySystemBackground
        }
    }
    
    /// 获取今天的 Todo 列表
    private func requestTodayTodoData() {
        // 筛选今天的数据
        let context = coreDataManager.context
        let request = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "startTime == %@", Date.now as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "endTime", ascending: true), NSSortDescriptor(key: "startTime", ascending: true)]
        if let todoData = try? context.fetch(request) {
            self.todoData = todoData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
        }
    }
    
    /// 获取时间线的 Todo 列表
    private func requestTimelineTodoData() {
        // 筛选时间线的 Todo 数据
    }
    
    /// 获取所有的 Todo 列表
    private func requestAllTodoData() {
        let context = coreDataManager.context
        let request = Todo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createTime", ascending: true), NSSortDescriptor(key: "orderId", ascending: true)]
        if let todoData = try? context.fetch(request) {
            self.todoData = todoData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
        }
    }
    
    /// 获取旗帜的 Todo 列表
    private func requestFlagTodoData() {
        let context = coreDataManager.context
        let request = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "flag == true")
        request.sortDescriptors = [NSSortDescriptor(key: "createTime", ascending: true), NSSortDescriptor(key: "orderId", ascending: true)]
        if let todoData = try? context.fetch(request) {
            self.todoData = todoData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
        }
    }
    
    /// 获取选定文件夹的 Todo 列表
    private func requestTodoDataFilteredByFolder() {
        let context = coreDataManager.context
        let request = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "folder.name == %@", currentFolder?.name ?? "")
        request.sortDescriptors = [NSSortDescriptor(key: "orderId", ascending: true)]
        if let todoData = try? context.fetch(request) {
            self.todoData = todoData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
        }
    }
    
    /// 用于在使用 StoryBoard 时初始化视图
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


// MARK: - UICollectionViewDataSource

extension TodoTableViewController: UICollectionViewDataSource {
    /// CollectionView 标题数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    /// 设置 Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TodoFolderHeaderCollectionViewCell
        
        cell.backgroundColor = .cellBackground
        cell.applyCornerRadius()
        let i = indexPath.row
        cell.configure(folderIcon: topEntries[i].icon, folderName: topEntries[i].name, itemNumber: topEntries[i].count)
        
        return cell
    }
    
}


// MARK: - UICollectionViewDelegate

extension TodoTableViewController: UICollectionViewDelegate {
    
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
    
}
