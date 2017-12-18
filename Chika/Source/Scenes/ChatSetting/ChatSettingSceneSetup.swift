//
//  ChatSettingSceneSetup.swift
//  Chika
//
//  Created Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ChatSettingSceneSetup: class {
    
    func formatTitle(in navigationItem: UINavigationItem)
    func format(cell: UITableViewCell, item: ChatSettingSceneItem?) -> Bool
    func formatHeaderView(_ view: ChatSettingSceneHeaderView, for item: ChatSettingSceneHeaderItem) -> Bool
    func formatHeaderView(_ view: ChatSettingSceneHeaderView, withTitle title: String) -> Bool
}

extension ChatSettingScene {
    
    class Setup: ChatSettingSceneSetup {
    
        var theme: ChatSettingSceneTheme
        
        init(theme: ChatSettingSceneTheme) {
            self.theme = theme
        }
        
        func formatTitle(in navigationItem: UINavigationItem) {
            navigationItem.title = "Chat Setting"
        }
        
        func format(cell: UITableViewCell, item: ChatSettingSceneItem?) -> Bool {
            var ok = false
            
            if let cell = cell as? ChatSettingSceneMemberCell, let item = item as? ChatSettingSceneMemberItem {
                cell.nameLabel.text = item.text
                
                switch item.action {
                case .none:
                    cell.onlineStatusView.isHidden = !item.isActive
                    cell.avatar.image = nil
                    cell.avatar.backgroundColor = theme.avatarBGColor
                    cell.selectionStyle = .none
                    
                case .add:
                    cell.avatar.image = #imageLiteral(resourceName: "chat_add_people")
                    cell.onlineStatusView.isHidden = true
                    cell.avatar.backgroundColor = theme.avatarBGColor.withAlphaComponent(0)
                    cell.selectionStyle = .gray
                
                case .showMore:
                    cell.avatar.image = #imageLiteral(resourceName: "chat_show_more")
                    cell.onlineStatusView.isHidden = true
                    cell.avatar.backgroundColor = theme.avatarBGColor.withAlphaComponent(0)
                    cell.selectionStyle = .gray
                
                case .showLess:
                    cell.avatar.image = #imageLiteral(resourceName: "chat_show_less")
                    cell.onlineStatusView.isHidden = true
                    cell.avatar.backgroundColor = theme.avatarBGColor.withAlphaComponent(0)
                    cell.selectionStyle = .gray
                }
                
                ok = true
            
            } else {
                if let item = item as? ChatSettingSceneOptionItem {
                    cell.textLabel?.text = item.label
                    cell.accessoryType = item.isDisclosureEnabled ? .disclosureIndicator : .none
                    
                    switch item.label.lowercased() {
                    case "leave":
                        cell.textLabel?.textColor = theme.destructiveTextColor
                    
                    default:
                        cell.textLabel?.textColor = theme.contactNameTextColor
                    }
                    
                } else {
                    cell.textLabel?.text = ""
                    cell.accessoryType = .none
                }
            }
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return ok
        }
        
        func formatHeaderView(_ view: ChatSettingSceneHeaderView, for item: ChatSettingSceneHeaderItem) -> Bool {
            view.titleLabel.text = item.title
            view.creatorLabel.text = item.creatorName.isEmpty ? "" : "created by \(item.creatorName)"
            view.setNeedsLayout()
            view.layoutIfNeeded()
            return true
        }
        
        func formatHeaderView(_ view: ChatSettingSceneHeaderView, withTitle title: String) -> Bool {
            view.titleLabel.text = title
            view.setNeedsLayout()
            view.layoutIfNeeded()
            return true
        }
    }
}
