//
//  TournamentTableVC+TableViewDelegate.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

// MARK: - Расширение для UITableViewDelegate
extension TournamentTableVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(teamObjects[indexPath.row].teamID)
        navigationController?.setNavigationBarHidden(false, animated: true)
        let teamVC = TeamVC()
        teamVC.teamID = teamObjects[indexPath.row].teamID
        navigationController?.pushViewController(teamVC, animated: true)
    }
}
