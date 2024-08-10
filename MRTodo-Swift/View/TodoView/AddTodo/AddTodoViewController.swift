//
//  AddTodoViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/10.
//

import UIKit

class AddTodoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .systemBackground
        
        self.navigationItem.title = "添加待办"
        // 完成按钮
        let doneButton = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(doneButton))
        self.navigationItem.rightBarButtonItem = doneButton
        // 取消按钮
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    /// 完成按钮执行函数
    @objc func doneButton() {
        // 用户点击了完成按钮
        self.dismiss(animated: true)
    }
    
    /// 取消按钮执行函数
    @objc func cancelButton() {
        // 用户点击了取消按钮
        self.dismiss(animated: true)
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
