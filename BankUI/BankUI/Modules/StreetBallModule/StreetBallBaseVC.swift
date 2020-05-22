//
//  StreetBallBaseVC.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

class StreetBallBaseVC: UIViewController, UINavigationControllerDelegate {

    // MARK: - Свойства
    private var direction: NavigationTitleAnimationDirection = .left

    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Турнирная таблица", "Календарь"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.9411764706, green: 0.7843137255, blue: 0, alpha: 1)
        segmentedControl.backgroundColor = .white
        segmentedControl.addTarget(self, action: #selector(segmentedControlTapped(segment:)), for: .valueChanged)
        return segmentedControl
    }()

    private let containerView: UIView = {
        let view = UIView()
        return view
    }()

    let mainVC = TournamentTableVC()
    let calendarVC = CalendarVC()

    // MARK: - Инициализация

    override func loadView() {
        super.loadView()
        setNavigationBar()
        setupGradientBackground()
        roundedCornersView()
         navigationController?.navigationBar.setupGradientNavigationBar(view: view, startGradientColor: #colorLiteral(red: 0.2745098039, green: 0.2862745098, blue: 0.2980392157, alpha: 1).cgColor, endGradientColor: #colorLiteral(red: 0.1215686275, green: 0.137254902, blue: 0.1490196078, alpha: 1).cgColor)
        setChild()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        //Так как мы не можем менять атрибуты для текста напрямую, то мы находим UILabel, который занимается его отображением, и настраиваем атрибуты для него
        for view in self.navigationController?.navigationBar.subviews ?? [] {
            let subviews = view.subviews
            if subviews.count > 0, let label = subviews[0] as? UILabel {
                label.textColor = #colorLiteral(red: 0.9411764706, green: 0.7843137255, blue: 0, alpha: 1)
                label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            }
        }
    }

    // MARK: - Настройка внешнего оформления

    private func setNavigationBar() {
        self.navigationItem.prompt = "Райффайзенбанк Лига 3 Х 3"
        self.navigationItem.titleView = segmentedControl
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9411764706, green: 0.7843137255, blue: 0, alpha: 1)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Лига 3 х 3", style: .plain, target: nil, action: nil)

        //Так как мы не можем менять атрибуты для текста напрямую, то мы находим UILabel, который занимается его отображением, и настраиваем атрибуты для него
//        if let promptClass = NSClassFromString("_UINavigationBarModernPromptView") as? UIAppearanceContainer.Type
//        {
//            let label = UILabel.appearance(whenContainedInInstancesOf: [promptClass])
//            label.textColor = #colorLiteral(red: 0.9411764706, green: 0.7843137255, blue: 0, alpha: 1)
//            label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
//        }
    }

    /// Установка фона View в Градиент
    private func setupGradientBackground() {
        let gradientView = BackgroundGradient(frame: view.frame)
        gradientView.startColor = ThemeManager.Color.startGradientColorForRoundedCorners
        gradientView.endColor = ThemeManager.Color.endGradientColor

        self.view.addSubview(gradientView)
    }

    /// Скругление Container View
    private func roundedCornersView() {
        containerView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(containerView)
        containerView.setPosition(top: self.view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        containerView.roundCorners(cornerRadius: 8)
    }

    ///Установка родительских VC  в контейнер
    private func setChild() {

        addChild(mainVC)
        mainVC.didMove(toParent: self)
        containerView.addSubview(mainVC.view)
        mainVC.view.setPosition(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        addChild(calendarVC)
        calendarVC.didMove(toParent: self)
        containerView.addSubview(calendarVC.view)
        calendarVC.view.setPosition(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        calendarVC.view.isHidden = true
    }

    // MARK: - Обработка нажатий

    ///Нажатия на SegmentControl
    @objc private func segmentedControlTapped(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            mainVC.view.isHidden = false
            calendarVC.view.isHidden = true
        }
        if segment.selectedSegmentIndex == 1 {
            mainVC.view.isHidden = true
            calendarVC.view.isHidden = false
        }
    }
}

extension StreetBallBaseVC: AnimationDirectionProtocol {
    /// Функция для того, чтобы задать направление анимации
    ///
    /// - Parameters:
    ///     - direction: Направление анимации
    func setDirection(direction: NavigationTitleAnimationDirection) {
        self.direction = direction
    }
}
