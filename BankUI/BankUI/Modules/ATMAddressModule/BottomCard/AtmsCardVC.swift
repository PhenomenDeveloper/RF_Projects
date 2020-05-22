//
//  AtmsCardVC.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 13.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class AtmsCardViewVC: UIViewController {

    var atmsInfo: [ATMMapModelProtocol]!

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .white
        return scrollView
    }()

    let pageControll: UIPageControl = {
        let pageControll = UIPageControl()
        pageControll.pageIndicatorTintColor = .black
        pageControll.currentPageIndicatorTintColor = UIColor(hexString: "FFDB00")
        pageControll.defersCurrentPageDisplay = true
        return pageControll
    }()

    var interactionDismiss: BottomCardInteractiveTransition?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
    }

    /// Установка UITableView
    private func configureView() {

        view.addSubview(scrollView)
        scrollView.fillToSuperView(view: view)
        scrollView.delegate = self

        view.addSubview(pageControll)
        pageControll.setPosition(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: self.view.bounds.height / 2, paddingRight: 0, width: 0, height: 0)
        pageControll.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControll.numberOfPages = atmsInfo.count
        pageControll.currentPage = 0

        DispatchQueue.main.async {
            self.setUpUI()
        }
    }

    private func setUpUI() {
        //Устанавливаем размер скрола на количетсво изображений
        scrollView.contentSize.width = self.view.bounds.width * CGFloat(atmsInfo.count)

        //Добавляем на скролл все изображения в соответствии с размером экрана
        for i in 0..<atmsInfo.count {
            let frame = CGRect(x: self.view.bounds.width * CGFloat(i), y: 0, width: self.view.bounds.width, height: self.view.bounds.height)

            let cardVC = CardViewVC()
            addChild(cardVC)
            cardVC.didMove(toParent: self)
            cardVC.view.frame = frame
            cardVC.arrowImage.isHidden = true
            cardVC.atmInfo = atmsInfo[i] as ATMListModelProtocol

            scrollView.addSubview(cardVC.view)
        }
    }
}

extension AtmsCardViewVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControll.currentPage = Int(pageIndex)
    }
}

extension AtmsCardViewVC: BottomCardShowProtocol {

    ///Размер отображаемой части
    var contentSize: CGFloat {
        return self.view.bounds.height / 2
    }

    ///Закрытие контроллера
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
}
