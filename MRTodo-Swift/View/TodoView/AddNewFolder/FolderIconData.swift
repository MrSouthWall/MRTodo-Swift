//
//  FolderIconData.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/17.
//

import Foundation

/// 新建文件夹页的单例模式数据，用于同步用户选择信息，并添加到 CoreData
class FolderIconData {
    
    // 单例模式必备
    static let shared = FolderIconData(icon: "list.bullet", color: "#2D91F5")
    
    // didSet，当数据被更改时发出通知
    var icon: String {
        didSet {
            NotificationCenter.default.post(name: .folderIconDataDidChange, object: nil)
        }
    }
    var color: String {
        didSet {
            NotificationCenter.default.post(name: .folderIconDataDidChange, object: nil)
        }
    }
    
    init(icon: String, color: String) {
        self.icon = icon
        self.color = color
    }
}
