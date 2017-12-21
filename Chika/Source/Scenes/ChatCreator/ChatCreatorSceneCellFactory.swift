//
//  ChatCreatorSceneCellFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ChatCreatorSceneCellFactory: class {
    
    var prototype: UITableViewCell? { get }
    
    func build(using: UITableView, reuseID: String) -> UITableViewCell
}

extension ChatCreatorSceneCell {
    
    class Factory: ChatCreatorSceneCellFactory {
    
        var prototype: UITableViewCell?
        var theme: ChatCreatorSceneTheme
        
        init(theme: ChatCreatorSceneTheme) {
            self.theme = theme
            self.prototype = ChatCreatorSceneCell()
        }
        
        func build(using tableView: UITableView, reuseID: String) -> UITableViewCell {
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseID)
            if cell == nil {
                let aCell =  ChatCreatorSceneCell(style: .default, reuseIdentifier: reuseID)
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
