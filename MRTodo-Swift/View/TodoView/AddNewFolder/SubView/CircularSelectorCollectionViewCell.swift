//
//  CircularSelectorCollectionViewCell.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/17.
//

import UIKit

class CircularSelectorCollectionViewCell: UICollectionViewCell {
    
    private let colorView = UIView()
    private let iconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupColorView()
        setupIconView()
    }
    
    private func setupColorView() {
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func setupIconView() {
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .darkGray
        contentView.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    /// 配置颜色
    func configureColor(with colorForHex: String) {
        colorView.backgroundColor = UIColor.colorForHex(colorForHex)
    }
    
    /// 配置圆角
    func configureCornerRadius(with cornerRadius: CGFloat) {
        colorView.applyCornerRadius(cornerRadius: cornerRadius)
    }
    
    /// 配置 Icon
    func configureIcon(with systemName: String) {
        iconView.image = UIImage(systemName: systemName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
