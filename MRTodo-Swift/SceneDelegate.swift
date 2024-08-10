//
//  SceneDelegate.swift
//  MRTodo-Swift
//
//  Created by 南墙先生 on 2024/8/9.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        /* 关于 Scene
         在 iOS 13 以上的版本中，系统支持多窗口，每个 UIWindowScene 实例就是一个窗口。
         而 UIWindow 才是真正放内容的地方，所以下文 TabBar 最后被添加到 UIWindow 的根视图中。
         +----------------------+
         | UIApplication        |
         |   +----------------+ |
         |   | UIWindowScene  | |
         |   |   +----------+ | |
         |   |   | UIWindow | | |
         |   |   +----------+ | |
         |   +----------------+ |
         +----------------------+
         */
        
        // 创建一个 UIWindow 放在 UIWindowScene 中
        window = UIWindow(windowScene: windowScene)

        // 检查用户是否首次启动
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "isShowStartView")
        // 如果是首次启动则打开欢迎页
        if isFirstLaunch {
            let startViewController = StartViewController()
            window?.rootViewController = startViewController
        } else {
            // 把 Window 的根视图设置为 TabBar
            window?.rootViewController = tabBarConfigure()
        }
        
        window?.makeKeyAndVisible() // 设置为关键窗口，确保窗口出现在屏幕上，并且用户可以与其交互
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    // MARK: - TabBarConfigure
    
    /// 配置 TabBar 标签栏视图
    func tabBarConfigure() -> UITabBarController {
        // 获取屏幕尺寸
        let screenSize = self.window?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        if screenSize == CGRect(x: 0, y: 0, width: 0, height: 0) {
            print("警告：获取屏幕尺寸出现错误！")
        }
        // 创建 TabBar
        let tabBarController = UITabBarController()
        // 分别创建四个视图。
        let calendarViewController = CalendarViewController()
        let todoTableViewController = TodoTableViewController(screenSize: screenSize, style: .insetGrouped)
        let tomatoClockViewController = TomatoClockViewController()
        let statistViewController = StatistViewController()
        // 给四个视图设置 TabBarItem 样式
        calendarViewController.tabBarItem = UITabBarItem(title: "日历日程", image: UIImage(systemName: "calendar"), tag: 0)
        
        todoTableViewController.tabBarItem = UITabBarItem(title: "待办事项", image: UIImage(systemName: "text.badge.checkmark"), tag: 1)
        let todoViewNavigationController = UINavigationController(rootViewController: todoTableViewController)
        
        tomatoClockViewController.tabBarItem = UITabBarItem(title: "番茄计时", image: UIImage(systemName: "timer"), tag: 2)
        
        statistViewController.tabBarItem = UITabBarItem(title: "统计趋势", image: UIImage(systemName: "chart.xyaxis.line"), tag: 3)
        // 把四个视图添加到 TabBar，按序添加
        tabBarController.viewControllers = [calendarViewController, todoViewNavigationController, tomatoClockViewController, statistViewController]
        return tabBarController
    }
}

