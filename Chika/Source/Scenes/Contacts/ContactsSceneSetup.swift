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
            
            cell.onlineStatusView.isHidden = !item.isActive
            cell.nameLabel.text = item.person.name
            cell.action = action
            cell.addButton.isHidden = action == nil
            
            let addButtonTitle: String
            let addButtonBGColor: UIColor
            
            switch item.requestStatus {
            case .none:
                addButtonTitle = "Send Request"
                addButtonBGColor = theme.addActionBGColor
            
            case .sent:
                addButtonTitle = "Sent"
                addButtonBGColor = theme.addActionOkayBGColor
                
            case .failed:
                addButtonTitle = "Retry"
                addButtonBGColor = theme.addActionFailedBGColor
                
            case .sending:
                addButtonTitle = "Sending"
                addButtonBGColor = theme.addActionActiveBGColor
            }
            
            cell.addButton.setTitle(addButtonTitle, for: .normal)
            cell.addButton.backgroundColor = addButtonBGColor
            
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
