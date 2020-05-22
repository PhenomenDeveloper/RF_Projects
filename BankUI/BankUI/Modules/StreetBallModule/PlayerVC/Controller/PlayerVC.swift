//
//  PlayerVC.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

class PlayerVC: UIViewController {

    var viewModel: PlayerViewModelProtocol!

    ///Вывод таблицы
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.allowsSelection = false
        return tv
    }()
    ///Вывод картинки
    let imagePlayer: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.black.cgColor
        image.contentMode = .scaleAspectFit

        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    ///Вывод имени
    let nameText: UILabel = {
        let name = UILabel()
            name.numberOfLines = 0
            name.text = "Фамилия\nИмя"
            name.textColor = .black
            name.font = UIFont.systemFont(ofSize: 25, weight: .semibold)

        return name

    }()
    ///Вывод названия команды
    let teamText: UILabel = {
        let team = UILabel()
            team.numberOfLines = 0
            team.text = "TeamID"
            team.textColor = .darkGray
            team.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        return team
    }()

    override func loadView() {
         super.loadView()
    }
    ///Инициализатор
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

//        setupNavigationBar()
        setupImagePlayer()
        setupNameText()
        setupTeamText()
        setupTableView()
        setUserData()
    }
    ///Размещение картинки на экране
    func setupImagePlayer() {
        imagePlayer.image = #imageLiteral(resourceName: "default")

        view.addSubview(imagePlayer)
        imagePlayer.setPosition(top: self.view.safeAreaLayoutGuide.topAnchor,
                                left: view.leftAnchor,
                                bottom: nil,
                                right: nil,
                                paddingTop: 20,
                                paddingLeft: 16,
                                paddingBottom: 0,
                                paddingRight: 0,
                                width: 125,
                                height: 125)
    }
    ///Размещение  Фамилия/Имя на экране
    func setupNameText() {
    view.addSubview(nameText)

    nameText.setPosition(top: view.safeAreaLayoutGuide.topAnchor,
                        left: imagePlayer.rightAnchor,
                        bottom: nil,
                        right: nil,
                        paddingTop: 20,
                        paddingLeft: 16,
                        paddingBottom: 0,
                        paddingRight: 0,
                        width: 0,
                        height: 60)
    }
    ///Инициализация команды и размещение её на экране
    func setupTeamText() {
    view.addSubview(teamText)

    teamText.setPosition(top: nameText.bottomAnchor,
                        left: imagePlayer.rightAnchor,
                        bottom: nil,
                        right: nil,
                        paddingTop: 25,
                        paddingLeft: 16,
                        paddingBottom: 0,
                        paddingRight: 0,
                        width: 0,
                        height: 50)
    }

    ///Размещение таблицы на экране
    func setupTableView() {
               tableView.delegate = self
               tableView.dataSource = self
               tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.bandCellId)

               view.addSubview(tableView)
               tableView.setPosition(top: imagePlayer.bottomAnchor,
                                     left: view.leftAnchor,
                                     bottom: view.bottomAnchor,
                                     right: view.rightAnchor,
                                     paddingTop: 30,
                                     paddingLeft: 0,
                                     paddingBottom: 0,
                                     paddingRight: 0,
                                     width: 0,
                                     height: 0)
           }
    ///Устанавливаем имя и фамилию игрока
    func setUserData() {
        nameText.text = viewModel.nameLabel
        teamText.text = viewModel.teamLabel
    }

}
