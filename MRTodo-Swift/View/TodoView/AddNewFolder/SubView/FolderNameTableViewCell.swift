//
//  FolderNameTableViewCell.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/13.
//

import UIKit

class FolderNameTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var icon: String = "list.bullet"
    var color: String = "#2D91F5"
    
    // 覆盖默认的初始化方法，提供默认值
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupFolderNameCell()
    }
    
    /// 设置视图
    private func setupFolderNameCell() {
        // 设置文件夹 Icon
        let folderIcon = FolderIcon(icon: icon, color: color, diameter: 100)
        self.contentView.addSubview(folderIcon)
        folderIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            folderIcon.heightAnchor.constraint(equalToConstant: folderIcon.diameter),
            folderIcon.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            folderIcon.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
        ])
        
        // 设置文件夹名字
        let folderName = UITextField(frame: .zero)
        folderName.backgroundColor = .systemGray5
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
            folderName.topAnchor.constraint(greaterThanOrEqualTo: folderIcon.bottomAnchor, constant: 20),
            folderName.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            folderName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            folderName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
