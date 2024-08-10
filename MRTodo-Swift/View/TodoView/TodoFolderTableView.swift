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
    
    /// Todo 列表文件夹数据
    let folderData = [
        "Don't Ask! Just Do It!",
        "Think And Dreams",
        "Work",
    ]
    
    /// 设置 Todo 文件夹列表 TableView
    private func setupTableView() {
        dataSource = self
        delegate = self
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
        print("获取到的：\(self.bounds)")
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


// MARK: - UITableViewDataSource

extension TodoFolderTableView: UITableViewDataSource {
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
        print(self.bounds.size.width)
        let headerView = UIView(frame: self.rectForHeader(inSection: 0))
        let titleLabel = UILabel(frame: headerView.bounds)
        titleLabel.text = "我的列表"
        titleLabel.textColor = .label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        headerView.addSubview(titleLabel)
        return headerView
    }
    
}


// MARK: - UITableViewDelegate

extension TodoFolderTableView: UITableViewDelegate {
    /// 选中行
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row \(indexPath.row)")
    }
    
    /// 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
