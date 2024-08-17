//
//  FolderIcon.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/12.
//

import UIKit

class FolderIcon: UIView {
    
    let folderIconData = FolderIconData.shared
    
    private let iconImage = UIImageView()
    private let circleView = UIView()
    
    /// Icon 背景圆形直径
    var diameter: Double = 50
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFolderIconData()
        setupView()
    }
    
    init(diameter: Double) {
        self.diameter = diameter
        super.init(frame: .zero)
        setupFolderIconData()
        setupView()
    }
    
    /// 更新视图和数据
    func setupFolderIconData() {
        // 更改圆形背景颜色
        circleView.backgroundColor = UIColor.colorForHex(folderIconData.color)
        circleView.applyShadow(color: UIColor.colorForHex(folderIconData.color), radius: 10)
        // 更改图片颜色
        iconImage.image = UIImage(systemName: folderIconData.icon)
    }
    
    private func setupView() {
        // 配置颜色
        circleView.applyCornerRadius(cornerRadius: diameter / 2)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(circleView)
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalToConstant: diameter),
            circleView.heightAnchor.constraint(equalToConstant: diameter),
            circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        // 配置 Icon
        iconImage.tintColor = .white
        iconImage.contentMode = .scaleAspectFit
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconImage)
        NSLayoutConstraint.activate([
            iconImage.widthAnchor.constraint(equalToConstant: diameter / 2),
            iconImage.heightAnchor.constraint(equalToConstant: diameter / 2),
            iconImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
