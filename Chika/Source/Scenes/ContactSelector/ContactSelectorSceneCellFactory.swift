//
//  ContactSelectorSceneCellFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactSelectorSceneCellFactory: class {
    
    var prototype: UITableViewCell? { get }
    
    func build(using: UITableView, reuseID: String) -> UITableViewCell
}

extension ContactSelectorSceneCell {
    
    class Factory: ContactSelectorSceneCellFactory {
    
        var prototype: UITableViewCell?
        var theme: ContactSelectorSceneTheme
        
        init(theme: ContactSelectorSceneTheme) {
            self.theme = theme
            self.prototype = ContactSelectorSceneCell()
        }
        
        func build(using tableView: UITableView, reuseID: String) -> UITableViewCell {
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseID)
            if cell == nil {
                let aCell =  ContactSelectorSceneCell()
                aCell.avatar.backgroundColor = theme.avatarBGColor
                aCell.nameLabel.textColor = theme.contactNameTextColor
                aCell.nameLabel.font = theme.contactNameFont
                aCell.selectButton.backgroundColor = theme.selectBGColor
                aCell.selectButton.tintColor = theme.selectTintColor
                aCell.selectButton.layer.borderColor = theme.selectBorderColor.cgColor
                aCell.selectButton.layer.borderWidth = 1
                cell = aCell
            }
            return cell
        }
    }
}
