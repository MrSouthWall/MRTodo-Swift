//
//  SetDetailView.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/24.
//

import SwiftUI

enum Priority: Int16 {
    case none = 0
    case low = 1
    case medium = 2
    case high = 3
}

struct SetDetailView: View {
    
    private let newTodoData = NewTodoData.shared
    
    @State private var isSetStartTime: Bool = false
    @State private var startTime: Date = Date()
    @State private var isSetEndTime: Bool = false
    @State private var endTime: Date = Date()
    @State private var flag: Bool = false
    @State private var prioritySelected: Priority = .none
    
    private let iconSize = 26.0
    
    var body: some View {
        Form {
            setDateSection
            setTagSection
            setFlagSection
            setPrioritySection
        }
    }
}


// MARK: - SubView

private extension SetDetailView {
    
    /// 设置日期 Section
    var setDateSection: some View {
        Section {
            HStack {
                SquareIcon(size: iconSize, color: .systemRed, icon: "calendar")
                Toggle("开始时间", isOn: $isSetStartTime.animation())
                    .padding(.leading, 5)
                    .onAppear {
                        if let startTime = newTodoData.startTime {
                            self.isSetStartTime = true
                            self.startTime = startTime
                        }
                    }
                    .onChange(of: isSetStartTime) { oldValue, newValue in
                        if newValue {
                            newTodoData.startTime = startTime
                        } else {
                            newTodoData.startTime = nil
                        }
                    }
            }
            if isSetStartTime {
                DatePicker("选择开始时间", selection: $startTime)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .onChange(of: startTime, initial: false) {
                        newTodoData.startTime = startTime
                    }
            }
            HStack {
                SquareIcon(size: iconSize, color: .systemBlue, icon: "calendar")
                Toggle("结束时间", isOn: $isSetEndTime.animation())
                    .padding(.leading, 5)
                    .onAppear {
                        if let endTime = newTodoData.endTime {
                            self.isSetEndTime = true
                            self.endTime = endTime
                        }
                    }
                    .onChange(of: isSetEndTime) { oldValue, newValue in
                        if newValue {
                            newTodoData.endTime = endTime
                        } else {
                            newTodoData.endTime = nil
                        }
                    }
            }
            if isSetEndTime {
                DatePicker("选择结束时间", selection: $endTime)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .onChange(of: endTime, initial: false) {
                        newTodoData.endTime = endTime
                    }
            }
        }
    }
    
    /// 设置标签 Section
    var setTagSection: some View {
        Section {
            HStack {
                SquareIcon(size: iconSize, color: .systemGray, icon: "tag.fill")
                Text("标签")
                    .padding(.leading, 5)
            }
        }
    }
    
    /// 设置旗帜 Section
    var setFlagSection: some View {
        Section {
            HStack {
                SquareIcon(size: iconSize, color: .systemOrange, icon: "flag.fill")
                Toggle("旗帜", isOn: $flag)
                    .padding(.leading, 5)
                    .onAppear {
                        flag = newTodoData.flag
                    }
                    .onChange(of: flag) {
                        newTodoData.flag = flag
                    }
            }
        }
    }
    
    /// 设置优先级 Section
    var setPrioritySection: some View {
        Section {
            HStack {
                SquareIcon(size: iconSize, color: .systemRed, icon: "exclamationmark")
                List {
                    Picker("优先级", selection: $prioritySelected) {
                        Text("无").tag(Priority.none)
                        Text("低").tag(Priority.low)
                        Text("中").tag(Priority.medium)
                        Text("高").tag(Priority.high)
                    }
                }
                .padding(.leading, 5)
                .onAppear {
                    prioritySelected = Priority(rawValue: newTodoData.priority) ?? .none
                }
                .onChange(of: prioritySelected) {
                    newTodoData.priority = prioritySelected.rawValue
                }
            }
        }
    }
}


// MARK: - #Preview

#Preview {
    SetDetailView()
}
