//
//  ChatSettingSceneCellFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ChatSettingSceneCellFactory: class {
    
    var prototype: UITableViewCell? { get }
    
    func build(using: UITableView, reuseID: String) -> UITableViewCell
}

extension ChatSettingSceneMemberCell {
    
    class Factory: ChatSettingSceneCellFactory {
    
        var theme: ChatSettingSceneTheme
        var prototype: UITableViewCell?
        
        init(theme: ChatSettingSceneTheme) {
            self.theme = theme
        }
    
        func build(using tableView: UITableView, reuseID: String) -> UITableViewCell {
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseID)
            if cell == nil {
                let aCell =  ChatSettingSceneMemberCell(style: .default, reuseIdentifier: reuseID)
                aCell.avatar.backgroundColor = theme.avatarBGColor
                aCell.avatar.tintColor = theme.contactNameTextColor
                aCell.nameLabel.textColor = theme.contactNameTextColor
                aCell.nameLabel.font = theme.contactNameFont
                aCell.onlineStatusView.backgroundColor = theme.onlineStatusColor
                cell = aCell
            }
            return cell
        }
    }
}

class ChatSettingSceneMemberCellFactory: ChatSettingSceneCellFactory {
    
    var theme: ChatSettingSceneTheme
    var prototype: UITableViewCell?
    
    init(theme: ChatSettingSceneTheme) {
        self.theme = theme
    }
    
    func build(using tableView: UITableView, reuseID: String) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseID)
        if cell == nil {
            cell =  UITableViewCell(style: .default, reuseIdentifier: reuseID)
            cell.textLabel?.font = theme.optionFont
            cell.textLabel?.textColor = theme.optionTextColor
            cell.selectionStyle = .gray
        }
        return cell
    }
}

protocol ChatSettingSceneMultipleCellFactory {
    
    func prototype(at indexPath: IndexPath) -> UITableViewCell?
    func build(using tableView: UITableView, reuseID: String, in section: Int, at row: Int) -> UITableViewCell
}

extension ChatSettingScene {
    
    class MultipleCellFactory: ChatSettingSceneMultipleCellFactory {
        
        var member: ChatSettingSceneCellFactory
        var option: ChatSettingSceneCellFactory
        
        init(member: ChatSettingSceneCellFactory, option: ChatSettingSceneCellFactory) {
            self.member = member
            self.option = option
        }
        
        convenience init(theme: ChatSettingSceneTheme) {
            let member = ChatSettingSceneMemberCell.Factory(theme: theme)
            let option = ChatSettingSceneMemberCellFactory(theme: theme)
            self.init(member: member, option: option)
        }
        
        func prototype(at indexPath: IndexPath) -> UITableViewCell? {
            switch indexPath.section {
            case 0: return member.prototype
            default: return nil
            }
        }
        
        func build(using tableView: UITableView, reuseID: String, in section: Int, at row: Int) -> UITableViewCell {
            switch section {
            case 0:
                return member.build(using: tableView, reuseID: reuseID)
            
            case 1:
                return option.build(using: tableView, reuseID: reuseID)
            default:
                return UITableViewCell()
            }
        }
    }
}
