//
//  AddNewFolderTableViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/12.
//

import UIKit

class AddNewFolderTableViewController: UITableViewController {
    
    private let icon: String = "list.bullet"
    private let color: String = "#2D91F5"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        setupNavigationBar()
        setupTableView()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        self.navigationItem.title = "新建文件夹"
        // 完成按钮
        let doneButton = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(doneButton))
        self.navigationItem.rightBarButtonItem = doneButton
        // 取消按钮
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    /// 设置 TableView
    private func setupTableView() {
        tableView.estimatedRowHeight = 200 // 预估行高
        tableView.rowHeight = UITableView.automaticDimension // 自动计算行高
        self.tableView.register(FolderNameCell.self, forCellReuseIdentifier: "FolderNameCell")
        self.tableView.register(FolderColorCell.self, forCellReuseIdentifier: "FolderColorCell")
        self.tableView.register(FolderIconCell.self, forCellReuseIdentifier: "FolderIconCell")
    }
    
    /// 完成按钮执行函数
    @objc private func doneButton() {
        // 用户点击了完成按钮
        self.dismiss(animated: true)
    }
    
    /// 取消按钮执行函数
    @objc private func cancelButton() {
        // 用户点击了取消按钮
        self.dismiss(animated: true)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FolderNameCell", for: indexPath) as! FolderNameCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FolderColorCell", for: indexPath) as! FolderColorCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FolderIconCell", for: indexPath) as! FolderIconCell
            return cell
        default:
            return UITableViewCell()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    // MARK: - Table view data Delegate
    
    /// 设置 Header 视图
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    /// 设置 Header 行高
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10
        default:
            return UITableView.automaticDimension // 自动计算
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - FolderNameCell

class FolderNameCell: UITableViewCell {
    
    var icon: String = "list.bullet"
    var color: String = "#2D91F5"
    
    // 覆盖默认的初始化方法，提供默认值
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupFolderNameCell()
    }
    
    /// 设置视图
    private func setupFolderNameCell() {
        // 设置文件夹 Icon
        let folderIcon = FolderIcon(icon: icon, color: color, diameter: 100)
        self.contentView.addSubview(folderIcon)
        folderIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            folderIcon.heightAnchor.constraint(equalToConstant: folderIcon.diameter),
            folderIcon.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            folderIcon.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
        ])
        
        // 设置文件夹名字
        let folderName = UITextField(frame: .zero)
        folderName.backgroundColor = .systemGray5
        folderName.applyCornerRadius()
        folderName.textAlignment = .center
        let placeholderString = "列表名称"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray, // 设置文本颜色
            .font: UIFont.boldSystemFont(ofSize: 22) // 设置字体
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderString, attributes: attributes)
        // 将 NSAttributedString 分配给文本字段的 attributedPlaceholder 属性
        folderName.attributedPlaceholder = attributedPlaceholder
        self.contentView.addSubview(folderName)
        folderName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            folderName.heightAnchor.constraint(equalToConstant: 50),
            folderName.topAnchor.constraint(greaterThanOrEqualTo: folderIcon.bottomAnchor, constant: 20),
            folderName.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            folderName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            folderName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - FolderColorCell

class FolderColorCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    let colorArray: [UIColor] = [
        .systemRed, .systemOrange, .systemYellow, .systemGreen, .systemTeal, .systemPink, .systemBlue,
        .systemRed, .systemOrange, .systemYellow, .systemGreen, .systemTeal, .systemPink, .systemBlue,
    ]

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }

    private func setupCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        let sectionInset = 12.0 // 四周边距
        flowLayout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        let diameter = 38 // 圆形色块的直径
        flowLayout.itemSize = CGSize(width: diameter, height: diameter)
        // 计算公式：两倍边距 + 一倍行间距 + 两倍元素尺寸
        let height = (flowLayout.sectionInset.top * 2) + flowLayout.minimumLineSpacing + (flowLayout.itemSize.height * 2)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: height), collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        /* 开发小插曲：这行代码真的诡异，其他代码不变，加上这行 Print，就会导致 CollectionView 内的 Cell 产生类似左对齐的效果，右边会空出一点
         print(flowLayout.collectionViewContentSize)
         */
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: height),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Collection View DataSource, Delegate

    /// Cell 个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }

    /// 设置 CollectionView 的 Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = colorArray[indexPath.row]
        return cell
    }

    // MARK: - Collection View Delegate

    /// 点击 Cell 执行
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at \(indexPath)")
    }
}


// MARK: - FolderIconCell

class FolderIconCell: UITableViewCell {
    
}
