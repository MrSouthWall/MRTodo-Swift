//
//  TodoHeaderCollectionViewCell.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/10.
//

import UIKit

class TodoHeaderCollectionViewCell: UICollectionViewCell {
    
    /// 文件夹 Icon
    private var folderIcon: FolderIcon = FolderIcon()
    
    /// 文件夹名称
    private let folderName: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    /// 文件夹内 Todo 数量
    private let itemNumber: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .right
        return label
    }()
    
    /// 设置信息
    func configure(folderIcon: FolderIcon, folderName: String, itemNumber: String) {
        self.folderIcon = folderIcon
        self.folderName.text = folderName
        self.itemNumber.text = itemNumber
        
        self.folderIcon.translatesAutoresizingMaskIntoConstraints = false
        self.folderName.translatesAutoresizingMaskIntoConstraints = false
        self.itemNumber.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.folderIcon)
        self.addSubview(self.folderName)
        self.addSubview(self.itemNumber)
        
        setupViews()
    }
    
    /// 设置视图
    private func setupViews() {
        // 设置约束
        NSLayoutConstraint.activate([
            folderIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            folderIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            folderIcon.widthAnchor.constraint(equalToConstant: 30),
            folderIcon.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            folderName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            folderName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            itemNumber.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            itemNumber.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
        ])
    }
    
}
