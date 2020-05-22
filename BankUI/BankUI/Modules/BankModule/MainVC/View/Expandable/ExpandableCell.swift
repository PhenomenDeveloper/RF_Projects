//
//  ExpandableCell.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 25.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class ExpandableCell: UICollectionViewCell {
    
    static let reuseId = "ExpandableCell"
    
    // MARK: - Свойства
    
    let accountCircleYellow: CircledDotView = {
        let circle = CircledDotView()
        circle.mainColor = #colorLiteral(red: 1, green: 0.8603625298, blue: 0, alpha: 1)
        circle.translatesAutoresizingMaskIntoConstraints = false

        return circle
    }()
    
    let accountCircleWhite: CircledDotView = {
        let circle = CircledDotView()
        circle.mainColor = .white
        circle.translatesAutoresizingMaskIntoConstraints = false

        return circle
    }()
    
    let accountImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .clear
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 10
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.8
        
        configureView()
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        
        contentView.addSubview(accountCircleYellow)
        accountCircleYellow.setPosition(top: nil,
                                        left: contentView.leftAnchor,
                                        bottom: nil,
                                        right: nil,
                                        paddingTop: 0,
                                        paddingLeft: 10,
                                        paddingBottom: 0,
                                        paddingRight: 0,
                                        width: 40,
                                        height: 40)
        accountCircleYellow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(accountCircleWhite)
        accountCircleWhite.setPosition(top: nil,
                                       left: nil,
                                       bottom: nil,
                                       right: nil,
                                       paddingTop: 0,
                                       paddingLeft: 0,
                                       paddingBottom: 0,
                                       paddingRight: 0,
                                       width: 36,
                                       height: 36)
        accountCircleWhite.centerYAnchor.constraint(equalTo: accountCircleYellow.centerYAnchor).isActive = true
        accountCircleWhite.centerXAnchor.constraint(equalTo: accountCircleYellow.centerXAnchor).isActive = true
        
        contentView.addSubview(accountImage)
        accountImage.setPosition(top: nil,
                                 left: nil,
                                 bottom: nil,
                                 right: nil,
                                 paddingTop: 0,
                                 paddingLeft: 0,
                                 paddingBottom: 0,
                                 paddingRight: 0,
                                 width: 24,
                                 height: 24)

        accountImage.centerYAnchor.constraint(equalTo: accountCircleYellow.centerYAnchor).isActive = true
        accountImage.centerXAnchor.constraint(equalTo: accountCircleYellow.centerXAnchor).isActive = true
        
        contentView.addSubview(nameLabel)

        nameLabel.setPosition(top: nil,
                              left: accountCircleYellow.rightAnchor,
                              bottom: nil,
                              right: contentView.rightAnchor,
                              paddingTop: 0,
                              paddingLeft: 12,
                              paddingBottom: 0,
                              paddingRight: 12,
                              width: 0,
                              height: 0)
        nameLabel.centerYAnchor.constraint(equalTo: accountCircleYellow.centerYAnchor).isActive = true
    }
}
