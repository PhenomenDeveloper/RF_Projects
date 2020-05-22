//
//  CustomImageButton.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButtonImage: UIControl {

    // MARK: - Свойства

    @IBInspectable var image: UIImage? {
        didSet {
            self.imageTitle.image = image
        }
    }

    let imageTitle: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: self.isHighlighted ? 0 : 0.25, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                self.alpha = self.isHighlighted ? 0.3 : 1
            })
        }
    }

    // MARK: - Инициализаторы

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Настройка внешнего вида для контрола

    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2.0
        setImage()
    }

    func setImage() {
        self.addSubview(imageTitle)
        imageTitle.setPosition(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 44)
        imageTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
