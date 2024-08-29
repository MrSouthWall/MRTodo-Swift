//
//  Folder.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/29.
//

import Foundation

extension Folder {
    
    /// 从 CoreData 取出数据
    static func requestWithOrderId() -> [Folder]{
        let context = MRCoreDataManager.shared.context
        let request = Folder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "orderId", ascending: true)]
        if let folderData = try? context.fetch(request) {
            return folderData
        } else {
            print("从 CoreData 取出文件夹数据失败！")
            return []
        }
    }
    
}
