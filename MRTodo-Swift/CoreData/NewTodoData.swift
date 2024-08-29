//
//  NewTodoData.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/18.
//

import Foundation

/// 新 Todo 的单例数据
class NewTodoData {
    
    static let shared = NewTodoData(createTime: .now, title: "", note: "", isDone: false, orderId: 0, folder: nil, flag: false, startTime: nil, endTime: nil, priority: 0)
    
    private let coreDataManager = MRCoreDataManager.shared
    
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
    var flag: Bool
    var startTime: Date?
    var endTime: Date?
    var priority: Int16
    
    private init(createTime: Date, title: String, note: String, isDone: Bool, orderId: Int16, folder: Folder?, flag: Bool, startTime: Date?, endTime: Date?, priority: Int16) {
        self.createTime = createTime
        self.title = title
        self.note = note
        self.isDone = isDone
        self.orderId = orderId
        self.folder = folder
        self.flag = flag
        self.startTime = startTime
        self.endTime = endTime
        self.priority = priority
        
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
        self.flag = false
        self.startTime = nil
        self.endTime = nil
        self.priority = 0
        
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
    
    /// 保存数据
    func saveToCoreData() {
        let context = coreDataManager.context
        // 存到 CoreData
        let newTodo = Todo(context: context)
        newTodo.createTime = createTime
        newTodo.title = title
        newTodo.note = note
        newTodo.isDone = isDone
        newTodo.orderId = orderId
        newTodo.folder = folder
        newTodo.flag = flag
        newTodo.startTime = startTime
        newTodo.endTime = endTime
        newTodo.priority = priority
        // 保存数据
        coreDataManager.saveContext()
    }
    
}
