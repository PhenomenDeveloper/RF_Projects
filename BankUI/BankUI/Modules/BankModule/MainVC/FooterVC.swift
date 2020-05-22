//
//  FooterVC.swift
//  BankUI
//
//  Created by MANVELYAN Gevorg on 14.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

private let footerCellIdentifier = "FooterCell"

class FooterVC: UIViewController {

    // MARK: - Свойства
    var collectionView: UICollectionView!
    let footerModel = FooterModel()
//    private let leftInset = 8

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        collectionView.alwaysBounceHorizontal = false
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        configureViewComponents()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(FooterCell.self, forCellWithReuseIdentifier: footerCellIdentifier)

    }

    // MARK: - Настройка внешнего вида

    func configureViewComponents() {
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        view.roundCorners(cornerRadius: 8)
//        collectionView.contentInset.left = CGFloat(leftInset)
        collectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(collectionView)
        collectionView.fillToSuperView(view: view)
    }
}

extension FooterVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return footerModel.titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: footerCellIdentifier, for: indexPath) as? FooterCell else { return UICollectionViewCell() }

            cell.textLabel.text = footerModel.titles[indexPath.item]
        if indexPath.row == 0 {
            cell.setupGradientsColor(startColor: #colorLiteral(red: 0.8274509804, green: 0.5137254902, blue: 0.07058823529, alpha: 1), endColor: #colorLiteral(red: 0.6588235294, green: 0.1960784314, blue: 0.4745098039, alpha: 1))
            return cell
        } else {

            cell.setupGradientsColor(startColor: #colorLiteral(red: 0.5764705882, green: 0.4039215686, blue: 0.6588235294, alpha: 1), endColor: #colorLiteral(red: 0.5254901961, green: 0.6588235294, blue: 0.9058823529, alpha: 1))

            return cell

        }

    }

}

extension FooterVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 158, height: 132)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let totalCellWidth = 158 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 12 * (collectionView.numberOfItems(inSection: 0) - 1)

        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)

    }

}
