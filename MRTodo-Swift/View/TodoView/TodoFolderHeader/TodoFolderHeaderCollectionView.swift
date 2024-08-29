//
//  TodoFolderHeaderCollectionView.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/10.
//

import UIKit

private let reuseIdentifier = "Cell"

class TodoFolderHeaderCollectionView: UICollectionView {
    
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
            todoTableViewController.setTodoData(todoData: Todo.requestWithToday())
            self.navigationController?.pushViewController(todoTableViewController, animated: true)
        case 1:
            let todoTableViewController = TodoItemTableViewController(style: .plain)
            todoTableViewController.todoFilteringMode = .timeline
            todoTableViewController.setTodoData(todoData: Todo.requestWithTimeline())
            self.navigationController?.pushViewController(todoTableViewController, animated: true)
        case 2:
            let todoTableViewController = TodoItemTableViewController(style: .plain)
            todoTableViewController.todoFilteringMode = .all
            todoTableViewController.setTodoData(todoData: Todo.requestWithAllTodo())
            self.navigationController?.pushViewController(todoTableViewController, animated: true)
        case 3:
            let todoTableViewController = TodoItemTableViewController(style: .plain)
            todoTableViewController.todoFilteringMode = .flag
            todoTableViewController.setTodoData(todoData: Todo.requestWithFlag())
            self.navigationController?.pushViewController(todoTableViewController, animated: true)
        default:
            break
        }
    }
    
}
