//
//  AboutCell.swift
//  BankUI
//
//  Created by KORNEEV Viktor on 13.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class AboutCell: UITableViewCell {

    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    let faceImageView: UIImageView = {
           let view = UIImageView()
           view.image = #imageLiteral(resourceName: "KolesnikovLev")
           view.contentMode = .scaleAspectFill
           view.translatesAutoresizingMaskIntoConstraints = false
           view.tintColor = .black
           return view

       }()

    let supportName: UILabel = {
         let label = UILabel()
         label.textColor = .black
         label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
         label.text = "SupportName"
         return label
     }()

    let position: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Стажер iOS"
        return label
    }()

    let cellLine: UIView = {
           let uiView = UIView()
           uiView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
           return uiView
       }()

    func setup() {
        addSubview(cellView)

        cellView.setPosition(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)

        cellView.addSubview(faceImageView)

        faceImageView.setPosition(top: cellView.topAnchor, left: cellView.leftAnchor, bottom: cellView.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 8, paddingBottom: 5, paddingRight: 0, width: 60, height: 60)

        cellView.addSubview(supportName)

        supportName.setPosition(top: cellView.topAnchor, left: faceImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        cellView.addSubview(position)

        position.setPosition(top: supportName.bottomAnchor, left: faceImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        cellView.addSubview(cellLine)

        cellLine.setPosition(top: position.bottomAnchor, left: cellView.leftAnchor, bottom: cellView.bottomAnchor, right: cellView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
