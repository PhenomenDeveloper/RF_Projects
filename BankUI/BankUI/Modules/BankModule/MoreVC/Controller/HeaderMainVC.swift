//
//  HeaderMainVC.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

private let headerCellIdentifier = "HeaderCell"

class HeaderMainVC: UIViewController {

    // MARK: - Свойства
    weak var delegate: GoToAdress?
    var collectionView: UICollectionView!
    let headerModel = HeaderModel()
    var networkUserData: NetworkUser!
    private let leftInset = 8

    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()

    let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()

    let mailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()

    let exitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.text = "Выйти"
        return label
    }()

    lazy var exitImageView: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "exit"), for: .normal)
        button.clipsToBounds = true
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        configureViewComponents()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: headerCellIdentifier)
        self.collectionView.register(HeaderAddressCell.self, forCellWithReuseIdentifier: HeaderAddressCell.reuseId)
    }

    public func setUserData() {
        nameLabel.text = networkUserData.name
        phoneLabel.text = networkUserData.mobilePhone.toPhoneNumber()
        mailLabel.text = networkUserData.email
    }

    // MARK: - Настройка внешнего вида

    func configureViewComponents() {

        self.view.addSubview(nameLabel)
        nameLabel.setPosition(top: self.view.safeAreaLayoutGuide.topAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, paddingTop: 24, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        self.view.addSubview(phoneLabel)
        phoneLabel.setPosition(top: nameLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        self.view.addSubview(mailLabel)
        mailLabel.setPosition(top: phoneLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        self.view.addSubview(exitImageView)
        exitImageView.setPosition(top: self.view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: self.view.rightAnchor, paddingTop: 37, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)

        self.view.addSubview(exitLabel)
        exitLabel.setPosition(top: nil, left: nil, bottom: nil, right: exitImageView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        exitLabel.centerYAnchor.constraint(equalTo: exitImageView.centerYAnchor).isActive = true

        collectionView.backgroundColor = .white
        view.roundCorners(cornerRadius: 8)
        collectionView.alwaysBounceHorizontal = true
        collectionView.contentInset.left = CGFloat(leftInset)
        collectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(collectionView)
        collectionView.setPosition(top: mailLabel.bottomAnchor, left: self.view.leftAnchor, bottom: view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 12, paddingRight: 0, width: 0, height: 80)
    }

    @objc func exitButtonTapped() {
        UserData.clearUserData()
        let regMenu = RegistrationMenu()
        regMenu.modalPresentationStyle = .fullScreen
        present(regMenu, animated: true, completion: nil)
    }
}

extension HeaderMainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerModel.titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderAddressCell.reuseId, for: indexPath) as? HeaderAddressCell else { return UICollectionViewCell() }
            cell.accessibilityIdentifier = "AddressCell"

            cell.titleLabel.text = headerModel.titles[indexPath.item]
            cell.subscriptionLabel.text = headerModel.subscriptions[indexPath.item]

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellIdentifier, for: indexPath) as? HeaderCell else { return UICollectionViewCell() }

            cell.accessibilityIdentifier = "HeaderCell"

            cell.textLabel.text = headerModel.titles[indexPath.item]
            cell.setupGradientsColor(startColor: headerModel.backgroundGradients[indexPath.item].0!, endColor: headerModel.backgroundGradients[indexPath.item].1!)

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let addressVC = ATMAddressBaseVC()
            addressVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(addressVC, animated: true)
        }
    }
}

extension HeaderMainVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 148, height: 80)
    }
}
