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
    private var collectionView: UICollectionView?
    let colorArray: [UIColor] = [
        .systemRed, .systemOrange, .systemYellow, .systemGreen, .systemTeal, .systemPink, .systemBlue,
        .systemRed, .systemOrange, .systemYellow, .systemGreen, .systemTeal, .systemPink, .systemBlue,
    ]

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }

    private func setupCollectionView() {
        let diameter = 40 // 圆形色块的直径
        let sectionInset = 12.0 // 四周边距
        let minimumLineSpacing = 12.0 // 行间距
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 12
        flowLayout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        flowLayout.itemSize = CGSize(width: diameter, height: diameter)
        self.collectionView = UICollectionView(frame: self.contentView.bounds, collectionViewLayout: flowLayout)
        if let collection = self.collectionView {
            collection.isScrollEnabled = false
            collection.delegate = self
            collection.dataSource = self
            collection.backgroundColor = .secondarySystemBackground
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            self.contentView.addSubview(collection)
            collection.translatesAutoresizingMaskIntoConstraints = false
            // 获取行数，目前仍有 Bug，在不同屏幕尺寸的手机上会导致不一样的结果
            let numberOfRows: Int = {
                // 获取collection view的宽度
                let collectionViewWidth = self.contentView.bounds.size.width
                // 获取item的宽度，包括item的最小间距
                let itemWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
                // 获取每行可以放置的item数量
                let itemsPerRow = ((collectionViewWidth - flowLayout.minimumInteritemSpacing) / itemWidth)
                // 计算总行数
                let numberOfItems = collectionView!.numberOfItems(inSection: 0)
                let numberOfRows = Int(Double(numberOfItems) / Double(itemsPerRow))
                return numberOfRows
            }()
            // 计算高度，计算方式：(圆色块的直径 * 行数) + (行间距 * 行数减一) + (上下边距)
            let collectionViewHeight = Double(diameter * numberOfRows) + minimumLineSpacing * Double(numberOfRows - 1) + sectionInset * 2
            NSLayoutConstraint.activate([
                collection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                collection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                collection.topAnchor.constraint(equalTo: contentView.topAnchor),
                collection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                collection.heightAnchor.constraint(greaterThanOrEqualToConstant: collectionViewHeight),
            ])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Collection View DataSource, Delegate

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = colorArray[indexPath.row]
        return cell
    }

    // MARK: - Collection View Delegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at \(indexPath)")
    }
}


// MARK: - FolderIconCell

class FolderIconCell: UITableViewCell {
    
}


/*
 //// MARK: - Collection View DataSource, Delegate

 //extension AddNewFolderTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
 //    private let items = Array(repeating: "Item", count: 10)
 //
 //    override func viewDidLoad() {
 //        super.viewDidLoad()
 //        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
 //    }
 //
 //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 //        return 10
 //    }
 //
 //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 //        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else {
 //            return UITableViewCell()
 //        }
 //
 //        cell.configure(with: items, delegate: self, dataSource: self)
 //        return cell
 //    }
 //
 //
 //}

 */
