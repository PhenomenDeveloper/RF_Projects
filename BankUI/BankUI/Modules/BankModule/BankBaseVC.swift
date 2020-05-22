//
//  BankBaseVC.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

// TO DO: Проверить Constraints

class BankBaseVC: UITabBarController {

    // MARK: - Свойства

    /// Текущий индекс TabBar для того, чтобы определять направление анимации
    var currentTabBarIndex: Int = 0
    private var previousTitle = "Главная"

    let mainVC = MainVC()
    let moreVC = MoreVC()
    let historyVC = InboxLogoVC()
    let settingsVC = SettingsVC()
    let streetBallVC = StreetBallBaseVC()

    // MARK: - Инициализаторы

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        configureViewController()

    }

    /// Установка фона View в Градиент
    private func setupGradientBackground() -> BackgroundGradient {
        let gradientView = BackgroundGradient(frame: view.frame)
        gradientView.startColor = ThemeManager.Color.startGradientColorForRoundedCorners
        gradientView.endColor = ThemeManager.Color.endGradientColor

        return gradientView
    }

    // MARK: - Расстановка UI элементов
    /// Настраиваем все страницы Tab Bar на необходимые контроллеры представления
    func configureViewController() {

        let main = constructNavController(unselectedImage: UIImage(named: "mainTB")!, rootViewController: mainVC, containerColor: #colorLiteral(red: 0.1700487137, green: 0.1845474541, blue: 0.1973886788, alpha: 1), navTitle: "Главная", tabBarTag: 0)

        let history = constructNavController(unselectedImage: UIImage(named: "historyTB")!, rootViewController: historyVC, navTitle: "История", tabBarTag: 1)

        let settings = constructNavController(unselectedImage: UIImage(named: "settingsTB")!, rootViewController: settingsVC, navTitle: "Настройки", tabBarTag: 2)

        let basketball = constructBasketBallVC(unselectedImage: UIImage(named: "basketballTB")!, rootViewController: streetBallVC, tabBarTitle: "Баскетбол", tabBarTag: 3)

        let more = constructNavController(unselectedImage: UIImage(named: "moreTB")!, rootViewController: moreVC, navTitle: "Ещё", tabBarTag: 4)

        //Добавляем созданные Контроллеры на ТАб бар
        viewControllers = [main, history, settings, basketball, more ]

        setupTabBar()
    }

    /// Установка TabBar
    func setupTabBar() {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard let tabItems = tabBar.items else { return }

        let numberOfItems = CGFloat(tabItems.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems + 10, height: tabBar.frame.height + 10 + (window?.safeAreaInsets.bottom ?? 0))
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: #colorLiteral(red: 1, green: 0.8588235294, blue: 0, alpha: 1), size: tabBarItemSize)

        tabBar.tintColor = .black
        tabBar.barTintColor = #colorLiteral(red: 0.9759238362, green: 0.9766622186, blue: 0.9760381579, alpha: 1)
        tabBar.isTranslucent = false
    }

    /// Создание NavigationController для баскетбольной лиги
    ///
    /// - Parameters:
    ///     - unselectedImage: Изображение которое представляет текущую страницу
    ///     - rootViewController: Родительский экран
    ///     - tabBarTitle: Заголовок для элемента Tab Bar
    ///     - tabBarTag: Порядковый номер в Tab Bar
    /// - Returns:
    ///     Созданный контроллер навигации
    func constructBasketBallVC(unselectedImage: UIImage, rootViewController: UIViewController, tabBarTitle: String, tabBarTag: Int) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.title = tabBarTitle
        navController.tabBarItem.tag = tabBarTag
        navController.navigationBar.tintColor = .black

        return navController
    }

    /// Настраивает контроллер навигации
    ///
    /// - Parameters:
    ///     - unselectedImage: Изображение которое представляет текущую страницу
    ///     - rootViewController: Родительский экран
    ///     - containerColor: Цвет контейнера, где лежат все элементы
    ///     - navTitle: Заголовок NavigationController
    ///     - tabBarTag: Порядковый номер в Tab Bar
    /// - Returns:
    ///     Созданный контроллер навигации
    private func constructNavController(unselectedImage: UIImage, rootViewController: UIViewController, containerColor: UIColor = ThemeManager.Color.backgroundColor, navTitle: String, tabBarTag: Int) -> UINavigationController {

        //Создаем контроллер навигации с необходимыми настройками
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.title = navTitle
        navController.tabBarItem.tag = tabBarTag

        navController.navigationBar.tintColor = .black

        navController.viewControllers.first?.navigationItem.title = navTitle

        navController.navigationBar.setupGradientNavigationBar(view: view, startGradientColor: ThemeManager.Color.startGradientColor.cgColor, endGradientColor: ThemeManager.Color.endGradientColor.cgColor)
        navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        navController.view.insertSubview(setupGradientBackground(), at: 0)

        return navController
    }

    /// Функция для установке направления анимации в зависимости от текущего индекса TabBar
    ///
    /// - Parameters:
    ///     - showVC: VC, которое необходимо отобразить
    ///     - deleteFirstVC: VC, которое необходимо удалить из superview
    ///     - deleteSecondVC: VC, которое необходимо удалить из superview
    ///     - tabBarItem: элемент Tab Bar
    private func setupAnimationDirection(showVC: AnimationDirectionProtocol, tabBarItem: UITabBarItem) {

        if currentTabBarIndex < tabBarItem.tag {
            showVC.setDirection(direction: .right)
        } else {
            showVC.setDirection(direction: .left)
        }

        currentTabBarIndex = tabBarItem.tag
    }

    private func setupPreviousTitle() {
        mainVC.navigationController?.viewControllers.first?.navigationItem.title = previousTitle
        historyVC.navigationController?.viewControllers.first?.navigationItem.title = previousTitle
        settingsVC.navigationController?.viewControllers.first?.navigationItem.title = previousTitle
        moreVC.navigationController?.viewControllers.first?.navigationItem.title = previousTitle
    }
}

extension BankBaseVC: UITabBarControllerDelegate {

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        switch item.tag {
        case 0:
            setupAnimationDirection(showVC: mainVC, tabBarItem: item)
            setupPreviousTitle()
        case 1:
            setupAnimationDirection(showVC: historyVC, tabBarItem: item)
            setupPreviousTitle()
        case 2:
            setupAnimationDirection(showVC: settingsVC, tabBarItem: item)
            setupPreviousTitle()
        case 3:
            setupAnimationDirection(showVC: streetBallVC, tabBarItem: item)
            setupPreviousTitle()
        case 4:
            setupAnimationDirection(showVC: moreVC, tabBarItem: item)
            setupPreviousTitle()

        default:
            break
        }

        guard let title = item.title else { return }
        previousTitle = title
    }

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarTransition(viewControllers: tabBarController.viewControllers)
    }
}

extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
