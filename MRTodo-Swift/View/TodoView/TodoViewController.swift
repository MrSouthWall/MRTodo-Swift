//
//  TodoViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/9.
//

import UIKit

class TodoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /// 设置导航栏
        self.navigationItem.title = "待办事项"
        
        // 设置右上角添加 Todo 按钮
        let addNewTodo = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(popupToAddNewTodo))
        self.navigationItem.rightBarButtonItem = addNewTodo
        
        // 设置文件夹列表
        let todoFolderTableView = TodoFolderTableView(frame: self.view.bounds, style: .insetGrouped)
        self.view.addSubview(todoFolderTableView)
    }
    
    /// 弹出添加新 Todo 视图
    @objc private func popupToAddNewTodo() {
        print("添加一个新 Todo")
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
