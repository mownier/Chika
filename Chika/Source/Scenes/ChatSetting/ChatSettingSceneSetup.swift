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
    func headerHeight(title: String?) -> CGFloat
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
                if item.isAddAction {
                    cell.nameLabel.text = "Add people"
                    cell.avatar.image = #imageLiteral(resourceName: "chat_add_people")
                    cell.onlineStatusView.isHidden = true
                    cell.avatar.backgroundColor = theme.avatarBGColor.withAlphaComponent(0)
                    cell.selectionStyle = .gray
                    
                } else {
                    cell.nameLabel.text = item.participant.displayName
                    cell.onlineStatusView.isHidden = !item.isActive
                    cell.avatar.image = nil
                    cell.avatar.backgroundColor = theme.avatarBGColor
                    cell.selectionStyle = .none
                }
                
                ok = true
            
            } else {
                if let item = item as? ChatSettingSceneOptionItem {
                    cell.textLabel?.text = item.label
                    cell.accessoryType = item.isDisclosureEnabled ? .disclosureIndicator : .none
                    
                } else {
                    cell.textLabel?.text = ""
                    cell.accessoryType = .none
                }
            }
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return ok
        }
        
        func headerHeight(title: String?) -> CGFloat {
            guard let title = title, !title.isEmpty else {
                return 0
            }
            
            return 24
        }
        
        func formatHeaderView(_ view: ChatSettingSceneHeaderView, for item: ChatSettingSceneHeaderItem) -> Bool {
            view.titleInput.text = item.title
            view.creatorLabel.text = item.creatorName.isEmpty ? "" : "created by \(item.creatorName)"
            return true
        }
    }
}
