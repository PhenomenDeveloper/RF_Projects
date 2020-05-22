//
//  BalanceVC.swift
//  BankUI
//
//  Created by MANVELYAN Gevorg on 12.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    // MARK: - Cвойства
    var containerView: UIView = UIView()
    var footerVC: FooterVC = FooterVC()
    var prevTitle: String?
    var isNeedAnimation: Bool = true
    var expandableModel = ExpandableModel()
    
    private var direction: NavigationTitleAnimationDirection = .left
    
    // MARK: - UI свойства
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    var contentSizeView: UIView = UIView()
    var constraintContentHeight: NSLayoutConstraint!
    
    private let layout = ExpandableCollectionViewFlowLayout()
    var constraintPaddingTopFromCollectionView: NSLayoutConstraint!
    lazy var expandableCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.isScrollEnabled = false
        return collection
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupTableView()
        setupExpandableCollection()
        setupFooterVC()
        
        tableView.register(CardsTableViewCell.self, forCellReuseIdentifier: CardsTableViewCell.reuseId)
        tableView.register(BalanceHeaderCell.self, forCellReuseIdentifier: BalanceHeaderCell.reuseId)
        tableView.register(AccountsTableViewCell.self, forCellReuseIdentifier: AccountsTableViewCell.reuseId)
        
        expandableCollectionView.register(ExpandableCell.self, forCellWithReuseIdentifier: ExpandableCell.reuseId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let navController = navigationController else { return }
        if !isNeedAnimation {
            addNavigationControllerTitleAnimation(navVC: navController, nextTitle: "Главная", direction: direction)
        }
        
        isNeedAnimation = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.async {

            var height: CGFloat = 0
            height += self.tableView.contentSize.height
            height += self.footerVC.collectionView.contentSize.height
            if self.layout.isExpandable {
                height += 380
            } else {
                height += 110
            }

            self.scrollView.contentSize = CGSize(width: self.scrollView.layer.bounds.width, height: height)
        }
    }
    
    private func setupScrollView() {
        self.view.addSubview(scrollView)
        scrollView.setPosition(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        scrollView.addSubview(contentSizeView)
        
        contentSizeView.fillToSuperView(view: scrollView)
        contentSizeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        constraintContentHeight = contentSizeView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        constraintContentHeight.isActive = true
    }
    
    /// Установка UITableView
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.isUserInteractionEnabled = false
        
        contentSizeView.addSubview(tableView)
        tableView.setPosition(top: contentSizeView.topAnchor,
                              left: contentSizeView.leftAnchor,
                              bottom: nil,
                              right: contentSizeView.rightAnchor,
                              paddingTop: 20,
                              paddingLeft: 4,
                              paddingBottom: 0,
                              paddingRight: 4,
                              width: 0,
                              height: 390)
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
        tableView.separatorInset.left = 60
        tableView.separatorInset.right = 4
    }
    
    private func setupExpandableCollection() {
        expandableCollectionView.delegate = self
        expandableCollectionView.dataSource = self
        
        contentSizeView.addSubview(expandableCollectionView)
        expandableCollectionView.setPosition(top: tableView.bottomAnchor, left: contentSizeView.leftAnchor, bottom: nil, right: contentSizeView.rightAnchor, paddingTop: 20, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 340)
    }
    
    private func setupFooterVC() {
        footerVC.view.backgroundColor = .clear
        contentSizeView.addSubview(footerVC.view)
        constraintPaddingTopFromCollectionView = footerVC.view.topAnchor.constraint(equalTo: expandableCollectionView.bottomAnchor)
        footerVC.view.setPosition(top: nil,
                                  left: contentSizeView.leftAnchor,
                                  bottom: nil,
                                  right: contentSizeView.rightAnchor,
                                  paddingTop: 0,
                                  paddingLeft: 0,
                                  paddingBottom: 0,
                                  paddingRight: 0,
                                  width: 0,
                                  height: 190)
        constraintPaddingTopFromCollectionView.isActive = true
        constraintPaddingTopFromCollectionView.constant = -260
        
        footerVC.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = BalanceHeaderCell(style: .default, reuseIdentifier: BalanceHeaderCell.reuseId)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.nameLabel.text = "Карты"
            return cell
        case 1:
            let cell = CardsTableViewCell(style: .default, reuseIdentifier: CardsTableViewCell.reuseId)
            cell.logoImage.image = #imageLiteral(resourceName: "creditcard")
            cell.miniImage.image = #imageLiteral(resourceName: "visabadge")
            cell.nameLabel.text = "Моя карта для покупок"
            cell.cardNumber.text = "*3424, кредитная"
            return cell
        case 2:
            let cell = CardsTableViewCell(style: .default, reuseIdentifier: CardsTableViewCell.reuseId)
            cell.logoImage.image = #imageLiteral(resourceName: "group22Copy2")
            cell.miniImage.image = #imageLiteral(resourceName: "mastercardbadge")
            cell.nameLabel.text = "#всёсразу"
            cell.cardNumber.text = "*3462"
            return cell
        case 3:
            let cell = BalanceHeaderCell(style: .default, reuseIdentifier: BalanceHeaderCell.reuseId)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.nameLabel.text = "Счета"
            return cell
        case 4:
            let cell = AccountsTableViewCell(style: .default, reuseIdentifier: AccountsTableViewCell.reuseId)
            cell.accountMiniImage.image = #imageLiteral(resourceName: "minicard")
            cell.accountImage.image = #imageLiteral(resourceName: "icRub")
            cell.nameLabel.text = "Текущий счёт"
            cell.accountNumber.text = "Кэшбечная, *4320"
            cell.balanceLabel.text = "1 050,00₽"
            return cell
        case 5:
            let cell = AccountsTableViewCell(style: .default, reuseIdentifier: AccountsTableViewCell.reuseId)
            cell.accountImage.image = #imageLiteral(resourceName: "icRub")
            cell.nameLabel.text = "На каждый день"
            cell.accountNumber.text = "*124389"
            cell.accountMiniCircleWhite.isHidden = true
            cell.accountMiniCircleBlack.isHidden = true
            return cell
        default:
            let cell = AccountsTableViewCell(style: .default, reuseIdentifier: AccountsTableViewCell.reuseId)
            return cell
        }
    }
}

extension MainVC: UITableViewDelegate {
    
}

extension MainVC: AnimationDirectionProtocol {
    /// Функция для того, чтобы задать направление анимации
    ///
    /// - Parameters:
    ///     - direction: Направление анимации
    func setDirection(direction: NavigationTitleAnimationDirection) {
        self.direction = direction
    }
    
}

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return expandableModel.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = expandableCollectionView.dequeueReusableCell(withReuseIdentifier: ExpandableCell.reuseId, for: indexPath) as? ExpandableCell else {return UICollectionViewCell()}
        
        cell.nameLabel.text = expandableModel.titles[indexPath.item]
        cell.accountImage.image = UIImage(named: expandableModel.imagesName[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 10.0
        
        return CGSize(width: width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        layout.isExpandable.toggle()
        
        if layout.isExpandable {
            scrollView.setContentOffset(CGPoint(x: 0, y: expandableCollectionView.layer.frame.minY), animated: true)
            performExpandAnimation(to: 0)
        } else {
            performExpandAnimation(to: -260, isExpandable: false)
        }
    }
    
    private func performExpandAnimation(to height: CGFloat, isExpandable: Bool = true) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState], animations: {
            self.constraintPaddingTopFromCollectionView.constant = height
            if isExpandable {
                self.viewDidLayoutSubviews()
            } else {
                self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), animated: true)
            }
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.viewDidLayoutSubviews()
        })
        
        self.expandableCollectionView.performBatchUpdates({
            self.expandableCollectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}
