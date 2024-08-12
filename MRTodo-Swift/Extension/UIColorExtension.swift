//
//  UIColorExtension.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/12.
//

import Foundation
import UIKit

extension UIColor {
    
    /// 通过 Hex 值获取 UIColor
    /// - Parameters:
    ///   - hex: “2D91F5”或“#2D91F5”皆可
    ///   - alpha: 透明度
    /// - Returns: UIColor 可选值，因为可能会获取失败
    static func colorForHex(_ hexString: String, alpha: CGFloat = 1.0) -> UIColor? {
        // 格式化字符，去除字符串两端的空白字符和换行符，转英文大写
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        // 删除 # 字符
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }
        // 判断字符串是否为 6 位，否则字符串值不对，返回 nil
        guard hex.count == 6 else {
            print("⚠️ MRFailed: Can't get UIcolor from \"\(hexString)\".")
            return nil
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
