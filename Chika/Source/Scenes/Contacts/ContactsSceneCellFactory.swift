//
//  ContactsSceneCellFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactsSceneCellFactory: class {
    
    var prototype: UITableViewCell? { get }
    
    func build(using: UITableView, reuseID: String, theme: ContactsSceneTheme) -> UITableViewCell
}

extension ContactsSceneCell {
    
    class Factory: ContactsSceneCellFactory {
        
        var prototype: UITableViewCell?
        
        init() {
            self.prototype = ContactsSceneCell()
        }
        
        func build(using tableView: UITableView, reuseID: String, theme: ContactsSceneTheme) -> UITableViewCell {
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseID)
            if cell == nil {
                let contactCell = ContactsSceneCell()
                contactCell.avatar.backgroundColor = theme.avatarBGColor
                contactCell.nameLabel.textColor = theme.contactNameTextColor
                contactCell.nameLabel.font = theme.contactNameFont
                contactCell.onlineStatusView.backgroundColor = theme.onlineStatusColor
                cell = contactCell
            }
            return cell
        }
    }
}
