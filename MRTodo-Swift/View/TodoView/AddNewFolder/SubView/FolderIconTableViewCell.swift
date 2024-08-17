//
//  FolderIconTableViewCell.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/13.
//

import UIKit

private let reuseIdentifierCell = "IconCell"

class FolderIconTableViewCell: UITableViewCell {
    
    // 获取数据
    let folderIconData = FolderIconData.shared
    
    private let iconArray: [String] = [
        "face.smiling", "list.bullet", "bookmark.fill", "mappin", "gift.fill", "birthday.cake.fill", "square.and.arrow.up.fill",
        "face.smiling", "list.bullet", "bookmark.fill", "mappin", "gift.fill", "birthday.cake.fill", "square.and.arrow.up.fill",
        "face.smiling", "list.bullet", "bookmark.fill", "mappin", "gift.fill", "birthday.cake.fill", "square.and.arrow.up.fill",
        "face.smiling", "list.bullet", "bookmark.fill", "mappin", "gift.fill", "birthday.cake.fill", "square.and.arrow.up.fill",
        "face.smiling", "list.bullet", "bookmark.fill", "mappin", "gift.fill", "birthday.cake.fill", "square.and.arrow.up.fill",
        "face.smiling", "list.bullet", "bookmark.fill", "mappin", "gift.fill", "birthday.cake.fill", "square.and.arrow.up.fill",
        "face.smiling", "list.bullet", "bookmark.fill", "mappin", "gift.fill", "birthday.cake.fill", "square.and.arrow.up.fill",
        "face.smiling", "list.bullet", "bookmark.fill", "mappin", "gift.fill", "birthday.cake.fill", "square.and.arrow.up.fill",
        "face.smiling", "list.bullet", "bookmark.fill", "mappin", "gift.fill", "birthday.cake.fill", "square.and.arrow.up.fill",
        "face.smiling", "list.bullet", "bookmark.fill", "mappin", "gift.fill", "birthday.cake.fill", "square.and.arrow.up.fill",
        "face.smiling", "list.bullet", "bookmark.fill", "mappin", "gift.fill", "birthday.cake.fill", "square.and.arrow.up.fill",
    ]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        let sectionInset = 12.0 // 四周边距
        flowLayout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        let diameter = 40 // 圆形色块的直径
        flowLayout.itemSize = CGSize(width: diameter, height: diameter)
        // 计算公式：两倍边距 + 一倍行间距 + 两倍元素尺寸
        let height = (flowLayout.sectionInset.top * 2) + flowLayout.minimumLineSpacing * 10 + (flowLayout.itemSize.height * 11)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CircularSelectorCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifierCell)
        self.contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
         /* 开发小插曲：这行代码真的诡异，其他代码不变，加上这行 Print，就会导致 CollectionView 内的 Cell 产生类似左对齐的效果，右边会空出一点
          print(flowLayout.collectionViewContentSize)
          */
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: height),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


// MARK: - Collection View DataSource

extension FolderIconTableViewCell: UICollectionViewDataSource {
    
    /// Cell 个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconArray.count
    }
    
    /// 设置 CollectionView 的 Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierCell, for: indexPath) as! CircularSelectorCollectionViewCell

        cell.configureColor(withUIcolor: .folderIconBackground)
        let cornerRadius = cell.bounds.width / 2
        cell.configureCornerRadius(with: cornerRadius)
        cell.configureIcon(with: iconArray[indexPath.row])
        
        return cell
    }
    
}


// MARK: - Collection View Delegate

extension FolderIconTableViewCell: UICollectionViewDelegate {
    
    /// 点击 Cell 执行
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 给数据赋值
        folderIconData.icon = iconArray[indexPath.row]
        print("用户选择了：\(iconArray[indexPath.row]) 图标")
    }
    
}
