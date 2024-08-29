//
//  Todo.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/29.
//

import Foundation

extension Todo {

    /// 获取今天的 Todo 列表
    static func requestWithToday() -> [Todo] {
        // 筛选今天的数据
        let context = MRCoreDataManager.shared.context
        let request = self.fetchRequest()
        request.predicate = NSPredicate(format: "startTime == %@", Date.now as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "endTime", ascending: true), NSSortDescriptor(key: "startTime", ascending: true)]
        if let todoData = try? context.fetch(request) {
            return todoData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
            return []
        }
    }
    
    /// 获取时间线的 Todo 列表
    static func requestWithTimeline() -> [Todo] {
        // 筛选时间线的 Todo 数据
        return []
    }
    
    /// 获取所有的 Todo 列表
    static func requestWithAllTodo() -> [Todo] {
        let context = MRCoreDataManager.shared.context
        let request = self.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createTime", ascending: true), NSSortDescriptor(key: "orderId", ascending: true)]
        if let todoData = try? context.fetch(request) {
            return todoData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
            return []
        }
    }
    
    /// 获取旗帜的 Todo 列表
    static func requestWithFlag() -> [Todo] {
        let context = MRCoreDataManager.shared.context
        let request = self.fetchRequest()
        request.predicate = NSPredicate(format: "flag == true")
        request.sortDescriptors = [NSSortDescriptor(key: "createTime", ascending: true), NSSortDescriptor(key: "orderId", ascending: true)]
        if let todoData = try? context.fetch(request) {
            return todoData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
            return []
        }
    }
    
    /// 获取选定文件夹的 Todo 列表
    static func requestWithFolder(folderName: String) -> [Todo] {
        let context = MRCoreDataManager.shared.context
        let request = self.fetchRequest()
        request.predicate = NSPredicate(format: "folder.name == %@", folderName)
        request.sortDescriptors = [NSSortDescriptor(key: "orderId", ascending: true)]
        if let todoData = try? context.fetch(request) {
            return todoData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
            return []
        }
    }
    
}
