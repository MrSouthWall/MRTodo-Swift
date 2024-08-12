//
//  FolderIcon.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/12.
//

import UIKit

class FolderIcon: UIView {
    
    private let icon: String
    private let color: String
    let diameter: Double
    
    init(icon: String, color: String, diameter: Double) {
        self.icon = icon
        self.color = color
        self.diameter = diameter
        super.init(frame: .zero)
        setupView()
    }
    
    private func setupView() {
        let circle = UIView(frame: .zero)
        circle.backgroundColor = UIColor.colorForHex(color)
        circle.applyCornerRadius(cornerRadius: diameter / 2)
        circle.applyShadow(color: UIColor.colorForHex(color), radius: 10)
        circle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(circle)
        NSLayoutConstraint.activate([
            circle.widthAnchor.constraint(equalToConstant: diameter),
            circle.heightAnchor.constraint(equalToConstant: diameter),
            circle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        let icon = UIImageView(image: UIImage(systemName: icon))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: diameter / 2),
            icon.heightAnchor.constraint(equalToConstant: diameter / 2),
            icon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
