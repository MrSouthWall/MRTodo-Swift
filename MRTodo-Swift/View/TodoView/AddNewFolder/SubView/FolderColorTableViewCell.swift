//
//  FolderColorTableViewCell.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/13.
//

import UIKit

class FolderColorTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    let colorArray: [UIColor] = [
        .systemRed, .systemOrange, .systemYellow, .systemGreen, .systemTeal, .systemPink, .systemBlue,
        .systemRed, .systemOrange, .systemYellow, .systemGreen, .systemTeal, .systemPink, .systemBlue,
    ]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        let sectionInset = 12.0 // 四周边距
        flowLayout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        let diameter = 38 // 圆形色块的直径
        flowLayout.itemSize = CGSize(width: diameter, height: diameter)
        // 计算公式：两倍边距 + 一倍行间距 + 两倍元素尺寸
        let height = (flowLayout.sectionInset.top * 2) + flowLayout.minimumLineSpacing + (flowLayout.itemSize.height * 2)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: height), collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
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
    
}


// MARK: - Collection View DataSource

extension FolderColorTableViewCell: UICollectionViewDataSource {
    
    /// Cell 个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    /// 设置 CollectionView 的 Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = colorArray[indexPath.row]
        cell.applyCornerRadius(cornerRadius: cell.bounds.width / 2)
        return cell
    }
    
}


// MARK: - Collection View Delegate

extension FolderColorTableViewCell: UICollectionViewDelegate {
    
    /// 点击 Cell 执行
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at \(indexPath)")
    }
    
}
