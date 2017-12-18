//
//  ContactSelectorSceneSetup.swift
//  Chika
//
//  Created Mounir Ybanez on 12/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactSelectorSceneSetup: class {
    
    func formatTitle(in navigationItem: UINavigationItem) -> Bool
    
    func format(cell: UITableViewCell, item: ContactSelectorSceneItem?, action: ContactSelectorSceneCellAction?) -> Bool
    func height(for cell: UITableViewCell?, item: ContactSelectorSceneItem?) -> CGFloat
}

extension ContactSelectorScene {
    
    class Setup: ContactSelectorSceneSetup {
    
        var theme: ContactSelectorSceneTheme
        
        init(theme: ContactSelectorSceneTheme) {
            self.theme = theme
        }
        
        func formatTitle(in navigationItem: UINavigationItem) -> Bool {
            navigationItem.title = "Select Contacts"
            return true
        }
        
        func format(cell: UITableViewCell, item: ContactSelectorSceneItem?, action: ContactSelectorSceneCellAction?) -> Bool {
            guard let cell = cell as? ContactSelectorSceneCell, let item = item else {
                return false
            }
            
            cell.nameLabel.text = item.contact.person.displayName
            cell.action = action
            cell.selectButton.setImage(item.isSelected ? #imageLiteral(resourceName: "check_icon") : nil, for: .normal)
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return true
        }
        
        func height(for cell: UITableViewCell?, item: ContactSelectorSceneItem?) -> CGFloat {
            guard let cell = cell as? ContactSelectorSceneCell, format(cell: cell, item: item, action: nil)  else {
                return 0
            }
            
            let height = max(cell.nameLabel.frame.maxY, cell.avatar.frame.maxY) + min(cell.nameLabel.frame.origin.y, cell.avatar.frame.origin.y) + 8
            return height
        }
    }
}
