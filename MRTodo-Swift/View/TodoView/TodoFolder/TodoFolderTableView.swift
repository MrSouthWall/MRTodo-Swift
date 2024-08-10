//
//  TodoFolderTableView.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/10.
//

import UIKit

class TodoFolderTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupTableView()
        setupTableHeaderView()
    }
    
    /// 用于在使用 StoryBoard 时初始化视图
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置 Todo 文件夹列表 TableView
    private func setupTableView() {
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    /// 设置 Todo 文件夹列表 HeaderView
    private func setupTableHeaderView() {
        let width = self.frame.width
        let height = 220.0
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (width - 60) / 2, height: (height - 60) / 2)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let todoFolderHeaderCollectionView = TodoFolderHeaderCollectionView(frame: CGRect(x: 0, y: 0, width: width, height: height), collectionViewLayout: layout)
        self.tableHeaderView = todoFolderHeaderCollectionView
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
