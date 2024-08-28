//
//  FolderIcon.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/12.
//

import UIKit

class FolderIcon: UIView {
    
    let newFolderData = NewFolderData.shared
    
    private let iconImage = UIImageView()
    private let circleView = UIView()
    
    /// Icon 背景圆形直径
    var diameter: Double = 50
    var iconName: String = "list.bullet"
    var hexColor: String = "#2D91F5"
    var isShoeShadow: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(circleView)
        self.addSubview(iconImage)
    }
    
    init(diameter: Double, iconName: String, hexColor: String, isShoeShadow: Bool) {
        self.diameter = diameter
        self.iconName = iconName
        self.hexColor = hexColor
        self.isShoeShadow = isShoeShadow
        super.init(frame: .zero)
        
        self.addSubview(circleView)
        self.addSubview(iconImage)
        setupFolderIconData()
    }
    
    /// 设置更新视图和数据
    func setupFolderIconData() {
        // 更改圆形背景颜色
        circleView.backgroundColor = UIColor.colorForHex(hexColor)
        if isShoeShadow {
            circleView.applyShadow(color: UIColor.colorForHex(hexColor), radius: 10)
        }
        // 更改图片颜色
        iconImage.image = UIImage(systemName: iconName)
        
        // 配置颜色
        circleView.applyCornerRadius(cornerRadius: diameter / 2)
        circleView.translatesAutoresizingMaskIntoConstraints = false
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
