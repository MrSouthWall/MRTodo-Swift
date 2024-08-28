//
//  FolderTableViewCell.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/28.
//

import UIKit

class FolderTableViewCell: UITableViewCell {
    
    private var folderIcon: FolderIcon = FolderIcon()
    private var folderName: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    func configureCell(folderIcon: FolderIcon, folderName: String) {
        self.folderIcon.diameter = folderIcon.diameter
        self.folderIcon.iconName = folderIcon.iconName
        self.folderIcon.hexColor = folderIcon.hexColor
        self.folderName.text = folderName
        self.folderIcon.setupFolderIconData()
    }
    
    private func setupCell() {
        folderIcon.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(folderIcon)
        NSLayoutConstraint.activate([
            folderIcon.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            folderIcon.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            folderIcon.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            folderIcon.widthAnchor.constraint(equalToConstant: folderIcon.diameter),
        ])
        
        folderName.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(folderName)
        NSLayoutConstraint.activate([
            folderName.leadingAnchor.constraint(equalTo: folderIcon.trailingAnchor, constant: 10),
            folderName.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            folderName.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            folderName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
        ])
    }
    
    
    // MARK: - 无用
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
