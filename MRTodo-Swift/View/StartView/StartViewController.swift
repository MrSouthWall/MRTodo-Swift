//
//  StartViewController.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/9.
//

import UIKit

class StartViewController: UIViewController {
    
    private let startScrollView: UIScrollView = UIScrollView() // 滚动视图
    private let pageControl = UIPageControl() // 控制器
    private let numberOfPages = 5 // 总页数
    
    private let nextButton: UIButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupContentViews()
        setupPageControl()
        setupButton()
    }
    
    
    // MARK: - SetupView
    
    /// 设置滚动视图
    private func setupScrollView() {
        startScrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 225)
        startScrollView.isPagingEnabled = true
        startScrollView.showsHorizontalScrollIndicator = false
        startScrollView.delegate = self
        view.addSubview(startScrollView)
    }
    
    /// 设置内容视图
    private func setupContentViews() {
        let pageWidth = startScrollView.bounds.width
        let pageHeight = startScrollView.bounds.height
        
        // 预览视图图片
        let images = [
            logoImageName(),
            "CalendarPreview",
            "TodoPreview",
            "StatisticPreview",
            "TomatoClockPreview",
        ]
        // 预览视图标题
        let titles = [
            "欢迎使用“MRTodo”",
            "日历日程",
            "待办事项",
            "统计趋势",
            "番茄钟",
        ]
        // 预览视图文字
        let texts = [
            "",
            "管理并查看你的日程安排和重要事件。",
            "创建、追踪和完成你的任务清单。",
            "分析和展示你的任务和时间管理趋势。",
            "利用番茄工作法提高工作效率并专注于任务。",
        ]
        
        for i in 0..<numberOfPages {
            let contentView = StartContentView(
                image: images[i],
                titleLabel: titles[i],
                contentLabel: texts[i],
                currentPage: i,
                width: pageWidth,
                height: pageHeight
            )
            startScrollView.addSubview(contentView)
        }
        startScrollView.contentSize = CGSize(width: pageWidth * CGFloat(numberOfPages), height: pageHeight)
    }
    
    /// 设置控制器
    private func setupPageControl() {
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .systemGray6
        pageControl.currentPageIndicatorTintColor = .accent
        pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: self.startScrollView.bottomAnchor, constant: 20),
        ])
    }
    
    /// 设置按钮
    private func setupButton() {
        updateButtonText()
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = .accent
        nextButton.applyCornerRadius()
        nextButton.applyShadow()
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
            nextButton.heightAnchor.constraint(equalToConstant: 45),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
        ])
    }
    
    
    // MARK: - Support
    
    /// 获取 Logo 图片名称
    private func logoImageName() -> String {
        if UITraitCollection.current.userInterfaceStyle == .light {
            return "MRTodo App Logo V1 - 1024x1024 - Light - RoundShadow"
        } else {
            return "MRTodo App Logo V1 - 1024x1024 - Dark - RoundShadow"
        }
    }
    
    /// 更新按钮文字
    private func updateButtonText() {
        // 设定为 3.001 是防止按钮文字二次闪烁，在用户拖动预览视图时，立刻对按钮文字进行更改
        if startScrollView.contentOffset.x <= view.bounds.width * 3 {
            nextButton.setTitle("继续", for: .normal)
        } else {
            nextButton.setTitle("完成", for: .normal)
        }
    }
    
    
    // MARK: - Button
    
    /// 页面控制器执行函数
    @objc private func pageControlValueChanged(_ sender: UIPageControl) {
        let pageIndex = sender.currentPage
        let offset = CGPoint(x: CGFloat(pageIndex) * view.bounds.width, y: 0)
        startScrollView.setContentOffset(offset, animated: true)
    }
    
    /// 点击按钮执行函数
    @objc private func nextButtonTapped() {
        if pageControl.currentPage < 4 {
            pageControl.currentPage += 1 // 计数
            // 翻页
            let pageWidth = startScrollView.frame.size.width;
            let offset = CGPoint(x: pageControl.currentPage * Int(pageWidth), y: 0)
            startScrollView.setContentOffset(offset, animated: true)
        } else {
            // 修改 UserDefaults，下次启动时不会再出现启动页
            UserDefaults.standard.set(true, forKey: "isShowStartView")
            // 获取当前的 SceneDelegate
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                // 切换视图到 TabBar
                sceneDelegate.window?.rootViewController = sceneDelegate.tabBarConfigure()
                // 配置切换动画
                UIView.transition(with: sceneDelegate.window!, duration: 1.0, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }
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


// MARK: - UIScrollViewDelegate
extension StartViewController: UIScrollViewDelegate {
    
    /// 设置视图滚动时执行的函数
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 通过偏移量求出当前页数，赋值给页面控制器
        let pageIndex = round(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = Int(pageIndex)
        updateButtonText()
    }
}
