//
//  TodoFolderHeaderCollectionViewCell.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/10.
//

import UIKit

class TodoFolderHeaderCollectionViewCell: UICollectionViewCell {
    
    /// 文件夹 Icon
    private let folderIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    /// 文件夹名称
    private let folderName: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    /// 文件夹内 Todo 数量
    private let itemNumber: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    /// 用于在使用 StoryBoard 时初始化视图
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    /// 设置信息
    func configure(folderIcon: String, folderName: String, itemNumber: String) {
        self.folderIcon.image = UIImage(systemName: folderIcon)
        self.folderName.text = folderName
        self.itemNumber.text = itemNumber
    }
    
    /// 设置视图
    private func setupViews() {
        self.addSubview(folderIcon)
        self.addSubview(folderName)
        self.addSubview(itemNumber)

        // 设置约束
        NSLayoutConstraint.activate([
            folderIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            folderIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            folderIcon.widthAnchor.constraint(equalToConstant: 30),
            folderIcon.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            folderName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            folderName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            itemNumber.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            itemNumber.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
        ])
    }
    
}
