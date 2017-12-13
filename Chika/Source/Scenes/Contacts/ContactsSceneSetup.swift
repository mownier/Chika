//
//  ContactsSceneSetup.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactsSceneSetup: class {

    func format(cell: UITableViewCell, theme: ContactsSceneTheme, item: ContactsSceneItem?, action: ContactsSceneCellAction?) -> Bool
    func height(for cell: UITableViewCell?, theme: ContactsSceneTheme, item: ContactsSceneItem?, action: ContactsSceneCellAction?) -> CGFloat
}

extension ContactsScene {
    
    class Setup: ContactsSceneSetup {
        
        func format(cell: UITableViewCell, theme: ContactsSceneTheme, item: ContactsSceneItem?, action: ContactsSceneCellAction?) -> Bool {
            guard let cell = cell as? ContactsSceneCell, let item = item else {
                return false
            }
            
            cell.nameLabel.font = theme.contactNameFont
            cell.onlineStatusView.isHidden = !item.isActive
            cell.nameLabel.text = item.contact.person.name
            cell.action = action
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return true
        }
        
        func height(for cell: UITableViewCell?, theme: ContactsSceneTheme, item: ContactsSceneItem?, action: ContactsSceneCellAction?) -> CGFloat {
            guard let contactCell = cell as? ContactsSceneCell, format(cell: contactCell, theme: theme, item: item, action: action)  else {
                return 0
            }
            
            let height = max(contactCell.nameLabel.frame.maxY, contactCell.avatar.frame.maxY) + min(contactCell.nameLabel.frame.origin.y, contactCell.avatar.frame.origin.y) + 8
            return height
        }
    }
}
