//
//  UIViewExtension.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/10.
//

import Foundation
import UIKit

extension UIView {
    
    /// 为图层添加阴影效果
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 阴影偏移
    ///   - opacity: 阴影透明度
    ///   - radius: 阴影模糊半径
    func applyShadow(color: UIColor = .black, offset: CGSize = CGSize(width: 0, height: 5), opacity: Float = 0.25, radius: CGFloat = 8.0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    /// 为图层添加圆角效果
    /// - Parameters:
    ///   - cornerRadius: 圆角半径
    ///   - masksToBounds: 是否裁剪（如若为 Ture，给图层添加阴影效果时，则阴影不会正常显示）
    func applyCornerRadius(cornerRadius: CGFloat = 10.0, masksToBounds: Bool = false) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = masksToBounds
    }
    
}
