//
//  TodoFolderHeaderCollectionView.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/10.
//

import UIKit

class TodoFolderHeaderCollectionView: UICollectionView {
    
    /// 初始化
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        // 设置视图
        setupCollectionView()
    }
    
    /// 用于在使用 StoryBoard 时初始化视图
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置待办事项文件夹列表的头部分类视图
    private func setupCollectionView() {
        self.backgroundColor = .systemGroupedBackground
        // 设置数据源和委托
        self.dataSource = self
        self.delegate = self
        self.register(TodoFolderHeaderCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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

extension TodoFolderHeaderCollectionView: UICollectionViewDataSource {
    /// CollectionView 标题数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    /// 设置 Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TodoFolderHeaderCollectionViewCell
        cell.backgroundColor = .secondarySystemBackground
        cell.applyCornerRadius()
        cell.applyShadow()
        
        let folderData: [(icon: String, name: String, count: String)] = [
            ("star.circle.fill", "今天", "0"),
            ("calendar", "计划", "3"),
            ("archivebox.circle", "所有", "10"),
            ("flag.fill", "旗帜", "7"),
        ]
        for i in indexPath {
            cell.configure(folderIcon: folderData[i].icon, folderName: folderData[i].name, itemNumber: folderData[i].count)
        }
        return cell
    }
    
}


// MARK: - UICollectionViewDelegate

extension TodoFolderHeaderCollectionView: UICollectionViewDelegate {
    
}
