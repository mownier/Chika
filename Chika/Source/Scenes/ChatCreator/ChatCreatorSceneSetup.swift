//
//  ChatCreatorSceneSetup.swift
//  Chika
//
//  Created Mounir Ybanez on 12/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ChatCreatorSceneSetup: class {
    
    func formatTitle(in navigationItem: UINavigationItem) -> Bool
    func format(cell: UITableViewCell, item: ChatCreatorSceneItem?, action: ChatCreatorSceneCellAction?) -> Bool
    func height(for cell: UITableViewCell?, item: ChatCreatorSceneItem?) -> CGFloat
}

extension ChatCreatorScene {
    
    class Setup: ChatCreatorSceneSetup {
    
        var theme: ChatCreatorSceneTheme
        
        init(theme: ChatCreatorSceneTheme) {
            self.theme = theme
        }
        
        func formatTitle(in navigationItem: UINavigationItem) -> Bool {
            navigationItem.title = "Create Chat"
            return true
        }
        
        func format(cell: UITableViewCell, item: ChatCreatorSceneItem?, action: ChatCreatorSceneCellAction?) -> Bool {
            guard let cell = cell as? ChatCreatorSceneCell, let item = item else {
                return false
            }
            
            cell.nameLabel.text = item.contact.person.displayName
            cell.action = action
            cell.selectButton.setImage(item.isSelected ? #imageLiteral(resourceName: "check_icon") : nil, for: .normal)
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return true
        }
        
        func height(for cell: UITableViewCell?, item: ChatCreatorSceneItem?) -> CGFloat {
            guard let cell = cell as? ChatCreatorSceneCell, format(cell: cell, item: item, action: nil)  else {
                return 0
            }
            
            let height = max(cell.nameLabel.frame.maxY, cell.avatar.frame.maxY) + min(cell.nameLabel.frame.origin.y, cell.avatar.frame.origin.y) + 8
            return height
        }
    }
}
