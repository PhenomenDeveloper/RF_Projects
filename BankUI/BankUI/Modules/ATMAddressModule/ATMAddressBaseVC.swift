//
//  ATMAddressBaseVC.swift
//  BankUI
//
//  Created by KOLESNIKOV Lev on 17.01.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

protocol GoToAdress: class {
    func goToAdress()
}

enum NavigationAtmsAndSubways {
    case Atms
    case Subways
    case AtmsMap
}

protocol ATMAdressBaseVCUpdateDataProtocol {
    func reloadDataForVC()
}

class ATMAddressBaseVC: UIViewController, UINavigationControllerDelegate {

    // MARK: - Свойства

    private let containerView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapNavigationBar))
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "На карте"
        return label
    }()

    let titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "shape")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "icFilter"), style: .plain, target: self, action: #selector(tapFilterButton))
        button.accessibilityIdentifier = "FiltersButton"
        return button
    }()

    lazy var dropDownCard: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    ///Положение верхней границы карточки представления
    private var bottomCardViewConstraint: NSLayoutConstraint!
    private var dropDownIsHidden = true

    let atmVC = ATMListVC()
    let subwayVC = SubwayListVC()
    let atmsMapVC = AtmsMapVC()
    let dropDownVC = DropDownVC()

    // MARK: - Инициализация

    override func loadView() {
        super.loadView()
        roundedCornersView()
        setChild()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.setupGradientNavigationBar(view: view, startGradientColor: ThemeManager.Color.yellowGradient.cgColor, endGradientColor: ThemeManager.Color.yellowGradient.cgColor)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        configureView()
        setNavigationBar()
        dropDownVC.delegate = self
        reloadDataForVC()

//        tabBarController?.tabBar.alpha = 0

        //Положение на экране для нижней границы выпадающего списка
        bottomCardViewConstraint = dropDownCard.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        bottomCardViewConstraint.isActive = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.navigationBar.setupGradientNavigationBar(view: view, startGradientColor: ThemeManager.Color.startGradientColor.cgColor, endGradientColor: ThemeManager.Color.endGradientColor.cgColor)
    }

    private func setNavigationBar() {
        titleView.addSubview(titleLabel)
        titleLabel.setPosition(top: titleView.topAnchor, left: titleView.leftAnchor, bottom: titleView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        titleView.addSubview(titleImage)
        titleImage.setPosition(top: titleView.topAnchor, left: titleLabel.rightAnchor, bottom: titleView.bottomAnchor, right: titleView.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 24, height: 24)

        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = filterButton

        navigationController?.navigationBar.tintColor = .black
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

        addChild(atmVC)
        atmVC.didMove(toParent: self)
        containerView.addSubview(atmVC.view)
        atmVC.view.setPosition(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        atmVC.view.isHidden = true

        addChild(subwayVC)
        subwayVC.didMove(toParent: self)
        containerView.addSubview(subwayVC.view)
        subwayVC.view.setPosition(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        subwayVC.view.isHidden = true

        addChild(atmsMapVC)
        atmsMapVC.didMove(toParent: self)
        containerView.addSubview(atmsMapVC.view)
        atmsMapVC.view.setPosition(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }

    private func configureView() {

        self.view.addSubview(dropDownCard)
        dropDownCard.setPosition(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)

        addChild(dropDownVC)
        dropDownVC.didMove(toParent: self)
        dropDownCard.addSubview(dropDownVC.view)
        dropDownVC.view.setPosition(top: dropDownCard.topAnchor, left: dropDownCard.leftAnchor, bottom: dropDownCard.bottomAnchor, right: dropDownCard.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }

    @objc func tapNavigationBar() {
        dropDownIsHidden ? showCardAnimation() : hideCardAnimations()
        dropDownIsHidden = !dropDownIsHidden
    }

    @objc func tapFilterButton() {
        let filterVC = ATMFiltersVC()
        navigationController?.pushViewController(filterVC, animated: true)
    }

    // MARK: - Анимация

    ///Анимация появления выпадающего списка с необходимой информацией
    private func showCardAnimation() {

        //Убеждаемся что перед запуском анимации нету ожидающих изменений для отрисовки view
        self.view.layoutIfNeeded()

        bottomCardViewConstraint.constant += dropDownCard.layer.bounds.height

        //Задаем анимацию для перемещения карточки вверх и обновляем представления для view
        let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.titleImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            self.dropDownVC.blurEffect.alpha = 1
            self.view.layoutIfNeeded()
        })

        showCard.startAnimation()
    }

    ///Анимация закрытия карточки
    private func hideCardAnimations() {

        self.view.layoutIfNeeded()

        bottomCardViewConstraint.constant = 0

        let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn) {
            self.titleImage.transform = CGAffineTransform(rotationAngle: CGFloat(2 * Double.pi))
            self.dropDownVC.blurEffect.alpha = 0.0
            self.view.layoutIfNeeded()
        }

        hideCard.startAnimation()
    }
}

extension ATMAddressBaseVC: SelectDropDownMenu {

    func select(titleName: String, navigation: NavigationAtmsAndSubways) {
        titleLabel.text = titleName
        dropDownIsHidden = true
        switch navigation {
        case .Atms:
            atmVC.view.isHidden = false
            subwayVC.view.isHidden = true
            atmsMapVC.view.isHidden = true
        case .Subways:
            atmVC.view.isHidden = true
            subwayVC.view.isHidden = false
            atmsMapVC.view.isHidden = true
        case .AtmsMap:
            atmVC.view.isHidden = true
            subwayVC.view.isHidden = true
            atmsMapVC.view.isHidden = false
        }

        hideCardAnimations()
    }
}

extension ATMAddressBaseVC: ATMAdressBaseVCUpdateDataProtocol {
    func reloadDataForVC() {
        atmVC.loadAtmsData(dataType: .allNeededAtms)
        subwayVC.loadSubways()
        atmsMapVC.loadAtmsForMap()
    }
}
