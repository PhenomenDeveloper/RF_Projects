//
//  TournamentTableVC+TableViewDataSource.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 20/12/2019.
//  Copyright © 2019 Korneev Viktor. All rights reserved.
//

import UIKit

// MARK: - Расширение для UITableViewDataSource
extension TournamentTableVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let rotationTransform = CATransform3DRotate(CATransform3DIdentity, CGFloat(Double.pi / 2), 500, 0, 0)
        cell.layer.transform = rotationTransform

        UIView.animate(withDuration: 1, delay: 0.05 * Double(indexPath.row), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTeams!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TournamentTableViewCell.reuseId, for: indexPath) as? TournamentTableViewCell else { return UITableViewCell() }

        cell.numberLabel.text = "\(indexPath.row + 1)"
        cell.teamAvatar.image = UIImage(named: teamObjects[indexPath.row].picture)
        cell.teamNameLabel.text = teamObjects[indexPath.row].name
        cell.teamWinrateLabel.text = "Победы \(teamObjects[indexPath.row].winScore) - \(teamObjects[indexPath.row].loseScore)"
        cell.teamScoreLabel.text = "\(teamObjects[indexPath.row].goalsScore) - \(teamObjects[indexPath.row].missedScore)"

        cell.accessibilityIdentifier = "TournamentCell"

        return cell
    }
}
