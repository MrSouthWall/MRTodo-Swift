//
//  SquareIcon.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/24.
//

import SwiftUI

struct SquareIcon: View {
    
    private let size: Double
    private let cornerRadius: Double
    private let color: UIColor
    private let icon: String
    
    init(size: Double, color: UIColor, icon: String) {
        self.size = size
        self.cornerRadius = size / (1024.0 / 228.0) // 苹果官方圆角尺寸
        self.color = color
        self.icon = icon
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: color)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .scaleEffect(0.6)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    SquareIcon(size: 100.0, color: .red, icon: "calendar")
}
