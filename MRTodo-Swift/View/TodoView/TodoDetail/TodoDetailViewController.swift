//
//  TodoDetailViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/9/2.
//

import UIKit

class TodoDetailViewController: UIViewController {
    
    private let todo: Todo
    
    init(todo: Todo) {
        self.todo = todo
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .systemBackground
        
        let todoDetail = UILabel()
        todoDetail.text = todo.description
        todoDetail.numberOfLines = 0
        self.view.addSubview(todoDetail)
        todoDetail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            todoDetail.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            todoDetail.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            todoDetail.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            todoDetail.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
