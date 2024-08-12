//
//  AddNewFolderViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/12.
//

import UIKit

class AddNewFolderViewController: UIViewController {
    
    private let icon: String = "list.bullet"
    private let color: String = "#2D91F5"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupInputView()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        self.navigationItem.title = "新建文件夹"
        // 完成按钮
        let doneButton = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(doneButton))
        self.navigationItem.rightBarButtonItem = doneButton
        // 取消按钮
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    /// 完成按钮执行函数
    @objc private func doneButton() {
        // 用户点击了完成按钮
        self.dismiss(animated: true)
    }
    
    /// 取消按钮执行函数
    @objc private func cancelButton() {
        // 用户点击了取消按钮
        self.dismiss(animated: true)
    }
    
    /// 设置视图
    private func setupInputView() {
        // 设置文件夹 Icon
        let folderIcon = FolderIcon(icon: icon, color: color, diameter: 100)
        self.view.addSubview(folderIcon)
        folderIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            folderIcon.widthAnchor.constraint(equalToConstant: folderIcon.diameter),
            folderIcon.heightAnchor.constraint(equalToConstant: folderIcon.diameter),
            folderIcon.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            folderIcon.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
        ])
        
        // 设置文件夹名字
        let folderName = UITextField(frame: .zero)
        folderName.backgroundColor = .systemGray5
        folderName.applyCornerRadius()
//        folderName.applyShadow()
        folderName.textAlignment = .center
        let placeholderString = "列表名称"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray, // 设置文本颜色
            .font: UIFont.boldSystemFont(ofSize: 22) // 设置字体
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderString, attributes: attributes)
        // 将 NSAttributedString 分配给文本字段的 attributedPlaceholder 属性
        folderName.attributedPlaceholder = attributedPlaceholder
        self.view.addSubview(folderName)
        folderName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            folderName.heightAnchor.constraint(equalToConstant: 50),
            folderName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            folderName.topAnchor.constraint(equalTo: folderIcon.bottomAnchor, constant: 30),
            folderName.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            folderName.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
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
