//
//  FolderNameTableViewCell.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/13.
//

import UIKit

class FolderNameTableViewCell: UITableViewCell {

    let newFolderData = NewFolderData.shared
    
    var folderIcon = FolderIcon()
    let folderName = UITextField()
    
    var isEnableDoneButton: (() -> Void)?
    
    // 覆盖默认的初始化方法，提供默认值
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupFolderNameCell()
        
        // 添加通知监听，当 .folderIconDataDidChange 通知触发时，执行 reloadView 函数
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: .folderIconDataDidChange, object: nil)
    }
    
    // 单对象被释放时，移除观察者，以避免潜在的内存泄漏问题
    deinit {
        NotificationCenter.default.removeObserver(self, name: .folderIconDataDidChange, object: nil)
    }
    
    /// 设置视图
    private func setupFolderNameCell() {
        // 设置文件夹 Icon
        folderIcon = FolderIcon(diameter: 100, iconName: newFolderData.icon, hexColor: newFolderData.color, isShoeShadow: true)
        self.contentView.addSubview(folderIcon)
        folderIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            folderIcon.heightAnchor.constraint(equalToConstant: folderIcon.diameter),
            folderIcon.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            folderIcon.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 30),
        ])
        
        // 设置文件夹名字
        folderName.delegate = self
        folderName.backgroundColor = .folderTextField
        folderName.applyCornerRadius()
        folderName.textAlignment = .center
        let placeholderString = "列表名称"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray, // 设置文本颜色
            .font: UIFont.boldSystemFont(ofSize: 22) // 设置字体
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderString, attributes: attributes)
        // 将 NSAttributedString 分配给文本字段的 attributedPlaceholder 属性
        folderName.attributedPlaceholder = attributedPlaceholder
        self.contentView.addSubview(folderName)
        folderName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            folderName.heightAnchor.constraint(equalToConstant: 50),
            folderName.topAnchor.constraint(greaterThanOrEqualTo: folderIcon.bottomAnchor, constant: 30),
            folderName.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -30),
            folderName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            folderName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
        ])
    }
    
    /// 更新数据
    @objc func reloadView() {
        folderIcon.iconName = newFolderData.icon
        folderIcon.hexColor = newFolderData.color
        folderIcon.setupFolderIconData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


//MARK: - UITextFieldDelegate

extension FolderNameTableViewCell: UITextFieldDelegate {
    
    // 文本编辑时，实时保存
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text {
            newFolderData.name = text
        }
        isEnableDoneButton?()
    }

    // 文本编辑结束时，按下回车，保存并关闭键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 读取文本字段的内容
        if let text = textField.text {
            newFolderData.name = text
        }
        // 关闭键盘
        textField.resignFirstResponder()
        return true
    }
    
}
