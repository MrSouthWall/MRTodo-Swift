//
//  NewFolderData.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/17.
//

import Foundation

private let defaultName = ""
private let defaultIcon = "list.bullet"
private let defaultColor = "#2D91F5"

/// 新建文件夹页的单例模式数据，用于同步用户选择信息，并添加到 CoreData
class NewFolderData {
    
    // 单例模式必备
    static let shared = NewFolderData(name: defaultName, icon: defaultIcon, color: defaultColor)
    
    private let coreDataManager = MRCoreDataManager.shared
    
    var name: String
    
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
    
    private init(name: String, icon: String, color: String) {
        self.name = name
        self.icon = icon
        self.color = color
    }
    
    /// 重置值为默认值
    func resetToDefault() {
        self.name = defaultName
        self.icon = defaultIcon
        self.color = defaultColor
    }
    
    /// 保存数据
    func saveToCoreData() {
        let context = coreDataManager.context
        let folder = Folder(context: context)
        folder.name = name
        folder.color = color
        folder.icon = icon
        // 取出 CoreData 数据，获取当前文件夹个数，并赋 orderId 值
        folder.orderId = Int16(Folder.requestWithOrderId().count - 1)
        // 保存数据
        coreDataManager.saveContext()
    }
    
}
