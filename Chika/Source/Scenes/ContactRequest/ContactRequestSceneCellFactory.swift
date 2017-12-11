//
//  ContactRequestSceneCellFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactRequestSceneCellFactory: class {
    
    var prototype: UITableViewCell? { get }
    
    func build(using: UITableView, reuseID: String, theme: ContactRequestSceneTheme) -> UITableViewCell
}

extension ContactRequestSceneCell {
    
    class Factory: ContactRequestSceneCellFactory {
    
        var prototype: UITableViewCell?
        
        init() {
            prototype = ContactRequestSceneCell()
        }
    
        func build(using tableView: UITableView, reuseID: String, theme: ContactRequestSceneTheme) -> UITableViewCell {
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseID)
            if cell == nil {
                let aCell =  ContactRequestSceneCell()
                aCell.avatar.backgroundColor = theme.avatarBGColor
                aCell.nameLabel.textColor = theme.nameTextColor
                aCell.messageLabel.textColor = theme.messageTextColor
                aCell.statusLabel.textColor = theme.statusTextColor
                aCell.statusLabel.backgroundColor = theme.statusBGColor
                aCell.accessoryType = .disclosureIndicator
                cell = aCell
            }
            return cell
        }
    }
}
