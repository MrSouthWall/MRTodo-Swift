//
//  TodoItemTableViewCell.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/10.
//

import UIKit

class TodoItemTableViewCell: UITableViewCell {
    
    /// 按钮闭包
    var buttonAction: (() -> Void) = {}
    
    /// 勾选 Icon
    let checkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    /// Todo 标题
    private let todoTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    /// todoNote
    private let todoNote: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(checkButton)
        self.contentView.addSubview(todoTitle)
        self.contentView.addSubview(todoNote)
        
        NSLayoutConstraint.activate([
            checkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
        ])
        NSLayoutConstraint.activate([
            todoTitle.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 20),
            todoTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
        ])
        NSLayoutConstraint.activate([
            todoNote.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 20),
            todoNote.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
    
    /// 配置 Cell 信息
    func configure(doneIcon: Bool, todoTitle: String, todoNote: String) {
        self.checkButton.setImage(UIImage(systemName: doneIcon ? "checkmark.circle" : "circle"), for: .normal)
        self.checkButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default), forImageIn: .normal)
        self.checkButton.addTarget(self, action: #selector(checkDone), for: .touchUpInside)
        self.todoTitle.text = todoTitle
        self.todoNote.text = todoNote
    }
    
    /// 编辑时让 Check 图标消失，结束编辑再出现
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        UIView.animate(withDuration: 0.5) {
            if self.isEditing {
                self.checkButton.alpha = 0
            } else {
                self.checkButton.alpha = 1
            }
        }
    }
    
    /// 按下 CheckButton 后执行
    @objc private func checkDone() {
        buttonAction()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
