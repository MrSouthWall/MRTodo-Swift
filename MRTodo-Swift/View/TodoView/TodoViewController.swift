//
//  TodoViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/9.
//

import UIKit

class TodoViewController: UIViewController {
    
    /// Todo 列表文件夹数据
    let folderData = [
        "Don't Ask! Just Do It!",
        "Think And Dreams",
        "Work",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 设置导航栏
        self.navigationItem.title = "待办事项"
        
        // 设置右上角添加 Todo 按钮
        let addNewTodo = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(popupToAddNewTodo))
        self.navigationItem.rightBarButtonItem = addNewTodo
        
        // 设置文件夹列表
        let todoFolderTableView = TodoFolderTableView(frame: self.view.bounds, style: .insetGrouped)
        todoFolderTableView.dataSource = self
        todoFolderTableView.delegate = self
        self.view.addSubview(todoFolderTableView)
        
        // 创建悬浮按钮
        let floatingButton = UIButton(type: .system)
        floatingButton.setImage(UIImage(systemName: "plus"), for: .normal)
        floatingButton.tintColor = .white
        floatingButton.backgroundColor = .systemBlue
        floatingButton.layer.cornerRadius = 30
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        // 将按钮添加到主视图中
        view.addSubview(floatingButton)
        // 设置按钮的位置
        NSLayoutConstraint.activate([
            floatingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        // 配置按钮点击事件
        floatingButton.addTarget(self, action: #selector(popupToAddNewTodo), for: .touchUpInside)

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
    
    /// 进入 Todo 条目列表
    func enterTodoTableView() {
        let todoTableViewController = TodoTableViewController(style: .grouped)
        self.navigationController?.pushViewController(todoTableViewController, animated: true)
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


// MARK: - UITableViewDataSource

extension TodoViewController: UITableViewDataSource {
    /// 行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderData.count
    }
    
    /// 设置 Todo 文件夹列表的 Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: "star")
        content.text = folderData[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    /// Header 的个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Header 的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    /// 设置 Header View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: tableView.rectForHeader(inSection: 0))
        let titleLabel = UILabel(frame: headerView.bounds)
        titleLabel.text = "我的列表"
        titleLabel.textColor = .label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        headerView.addSubview(titleLabel)
        return headerView
    }
    
}


// MARK: - UITableViewDelegate

extension TodoViewController: UITableViewDelegate {
    /// 选中行
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row \(indexPath.row)")
        let todoTableViewController = TodoTableViewController(style: .grouped)
        self.navigationController?.pushViewController(todoTableViewController, animated: true)
    }
    
    /// 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
