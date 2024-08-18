//
//  NewTodoData.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/18.
//

import Foundation

/// 新 Todo 的单例数据
class NewTodoData {
    
    static let shared = NewTodoData(createTime: .now, title: "", note: "", isDone: false, orderId: 0, folder: nil)
    
    var createTime: Date
    var title: String
    var note: String
    var isDone: Bool
    var orderId: Int16
    var folder: Folder? {
        didSet {
            NotificationCenter.default.post(name: .newTodoFolderDataDidChange, object: nil)
        }
    }
    
    init(createTime: Date, title: String, note: String, isDone: Bool, orderId: Int16, folder: Folder?) {
        self.createTime = createTime
        self.title = title
        self.note = note
        self.isDone = isDone
        self.orderId = orderId
        self.folder = folder
        
        getFirstFolder()
    }
    
    /// 重置值为默认值
    func resetToDefault() {
        self.createTime = .now
        self.title = ""
        self.note = ""
        self.isDone = false
        self.orderId = 0
        self.folder = nil
        
        getFirstFolder()
    }
    
    /// 获取第一个文件夹
    func getFirstFolder() {
        let coreDataManager = MRCoreDataManager.shared
        let context = coreDataManager.context
        let request = Folder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "orderId", ascending: true)]
        if let folderData = try? context.fetch(request) {
            self.folder = folderData.first
        } else {
            print("给 newTodoData 赋值文件夹数据失败！")
        }
    }
    
}
