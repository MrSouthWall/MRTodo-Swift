//
//  StartContentView.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/9.
//

import UIKit

class StartContentView: UIView {
    
    private let imageView: UIImageView
    private let titleLabel: UILabel
    private let contentLabel: UILabel
    private let currentPage: Int
    private let width: CGFloat
    private let height: CGFloat
    
    /// 通过给到三个信息初始化视图
    init(image: String, titleLabel: String, contentLabel: String, currentPage: Int, width: CGFloat, height: CGFloat) {
        self.imageView = UIImageView(image: UIImage(named: image))
        self.titleLabel = UILabel()
        self.titleLabel.text = titleLabel
        self.contentLabel = UILabel()
        self.contentLabel.text = contentLabel
        self.currentPage = currentPage
        self.width = width
        self.height = height
        
        super.init(frame: CGRect(x: width * CGFloat(currentPage), y: 0, width: width, height: height))

        setupView()
    }
    
    /// 用于在使用 StoryBoard 时初始化视图
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置视图
    private func setupView() {
        // 设置图片
        imageView.sizeToFit()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 100),
        ])
        // Logo 页和别的页分别设置
        if currentPage == 0 { // 设置 Logo 页
            // 设置图片
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 175),
                imageView.heightAnchor.constraint(equalToConstant: 175),
            ])
            // 设置标题
            titleLabel.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle2)
            titleLabel.textColor = .label
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(titleLabel)
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 60),
            ])
        } else { // 设置简介页
            // 设置说明文字
            contentLabel.font = UIFont.preferredFont(forTextStyle: .body)
            contentLabel.textColor = .label
            contentLabel.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(contentLabel)
            NSLayoutConstraint.activate([
                contentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                contentLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            ])
            // 设置标题
            titleLabel.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle2)
            titleLabel.textColor = .label
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(titleLabel)
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: contentLabel.topAnchor, constant: -20),
            ])
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
