//
//  BankMainVC.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

enum NavigationTitleAnimationDirection {
    case left
    case right
}

class MoreVC: UIViewController {

    var prevTitle: String?

    var containerView: UIView = UIView()

    // MARK: - Свойства для бейджа уведомлений

    lazy var notificationView: NotificationView = {
        let view = NotificationView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.delegate = self
        return view
    }()

    ///Таймер для имитации получения уведомлений
    lazy var timer = Timer(timeInterval: 1.5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)

    ///Проверил ли пользователь непрочитанные уведомления
    private var isNotificationsChecked = false
    ///Количество непрочитанных уведомлений
    private var notificationCount = 0

    private var direction: NavigationTitleAnimationDirection = .left
    /// Свойство, которое отвечает за необходимость воспроизведения анимации при открытии VC
    var isNeedAnimation: Bool = true
    var contentSizeView: UIView = UIView()
    var constraintContentHeight: NSLayoutConstraint!

    let viewSettings: UIView = {
        let view = UIView()
        return view
    }()

    let settingsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 153 / 255, green: 153 / 255, blue: 153 / 255, alpha: 1)
        label.text = "Настройки"
        return label
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    var headerVC: HeaderMainVC = HeaderMainVC()
    var tableMainVC: TableMainVC = TableMainVC()

    // MARK: - Инициализаторы

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .clear

        setupContainerView(container: containerView, containerColor: ThemeManager.Color.backgroundColor)
        setupScrollView()
        configureViewComponents()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        RunLoop.current.add(timer, forMode: .common)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let navController = navigationController else { return }
        addNavigationControllerTitleAnimation(navVC: navController, nextTitle: "Еще", direction: direction)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.async {

            var height: CGFloat = 0
            height += self.headerVC.view.frame.height
            height += self.viewSettings.frame.height
            height += self.tableMainVC.tableView.contentSize.height

            self.scrollView.contentSize = CGSize(width: self.scrollView.layer.bounds.width, height: height)
        }
    }

    @objc func backToLogin() {
        self.dismiss(animated: true)
    }

    // MARK: - Настройка внешнего вида

    private func setupScrollView() {
        self.view.addSubview(scrollView)
        scrollView.setPosition(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        scrollView.addSubview(contentSizeView)

        contentSizeView.fillToSuperView(view: scrollView)
        contentSizeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        constraintContentHeight = contentSizeView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        constraintContentHeight.isActive = true
    }

    func configureViewComponents() {

        addChild(headerVC)
        headerVC.didMove(toParent: self)
        contentSizeView.addSubview(headerVC.view)
        headerVC.view.setPosition(top: contentSizeView.topAnchor, left: contentSizeView.leftAnchor, bottom: nil, right: contentSizeView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 190)

        contentSizeView.addSubview(viewSettings)
        viewSettings.setPosition(top: headerVC.view.bottomAnchor, left: contentSizeView.leftAnchor, bottom: nil, right: contentSizeView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 48)

        viewSettings.addSubview(settingsLabel)
        settingsLabel.setPosition(top: viewSettings.topAnchor, left: viewSettings.leftAnchor, bottom: viewSettings.bottomAnchor, right: nil, paddingTop: 24, paddingLeft: 16, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)

        addChild(tableMainVC)
        tableMainVC.didMove(toParent: self)
        contentSizeView.addSubview(tableMainVC.view)
        tableMainVC.view.setPosition(top: viewSettings.bottomAnchor, left: contentSizeView.leftAnchor, bottom: view.bottomAnchor, right: contentSizeView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableMainVC.tableView.isScrollEnabled = false
    }
}

extension MoreVC: CheckNotificationsProtocol {

    @objc func handleTimer() {
        notificationCount += 1
        notificationView.setLabel(with: notificationCount)

        if notificationCount > 3 {
            notificationView.setLabel(with: 10)
            timer.invalidate()
        }
    }

    func checkNotification() {

        if isNotificationsChecked {
            notificationCount = 0
            timer = Timer(timeInterval: 1.5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
        } else {
            timer.invalidate()
            notificationCount = 0
        }
        isNotificationsChecked = !isNotificationsChecked
    }
}

extension MoreVC: AnimationDirectionProtocol {
    /// Функция для того, чтобы задать направление анимации
    ///
    /// - Parameters:
    ///     - direction: Направление анимации
    func setDirection(direction: NavigationTitleAnimationDirection) {
        self.direction = direction
    }
}

extension MoreVC: SetupContainerViewProtocol {
    func setupContainerView(container: UIView, containerColor: UIColor) {
         containerView.backgroundColor = containerColor
         containerView.translatesAutoresizingMaskIntoConstraints = false

         view.addSubview(containerView)
        containerView.setPosition(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
         containerView.roundCorners(cornerRadius: ThemeManager.Corner.containerViewCornerRadius)
     }
}
