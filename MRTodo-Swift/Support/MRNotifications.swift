//
//  MRNotifications.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/17.
//

import Foundation

extension Notification.Name {
    
    /// 新建文件夹 Icon 数据变更
    static let folderIconDataDidChange = Notification.Name("folderIconDataDidChange")
    
    /// 新建 Todo 页面中的 Folder 数据变更
    static let newTodoFolderDataDidChange = Notification.Name("newTodoFolderDataDidChange")
}
