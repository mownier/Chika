//
//  PeopleSearchSceneCellFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/12/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol PeopleSearchSceneCellFactory: class {
    
    var prototype: UITableViewCell? { get }
    
    func build(using: UITableView, reuseID: String, theme: PeopleSearchSceneTheme) -> UITableViewCell
}

extension PeopleSearchSceneCell {
    
    class Factory: PeopleSearchSceneCellFactory {
    
        var prototype: UITableViewCell?
    
        init() {
            self.prototype = PeopleSearchSceneCell()
        }
        
        func build(using tableView: UITableView, reuseID: String, theme: PeopleSearchSceneTheme) -> UITableViewCell {
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseID)
            if cell == nil {
                let aCell =  PeopleSearchSceneCell(style: .default, reuseIdentifier: reuseID)
                aCell.avatar.backgroundColor = theme.avatarBGColor
                aCell.nameLabel.textColor = theme.nameTextColor
                aCell.nameLabel.font = theme.nameFont
                aCell.onlineStatusView.backgroundColor = theme.onlineStatusColor
                aCell.addButton.backgroundColor = theme.addActionBGColor
                aCell.addButton.setTitleColor(theme.addActionTextColor, for: .normal)
                aCell.addButton.titleLabel?.font = theme.addActionFont
                cell = aCell
            }
            return cell
        }
    }
}
