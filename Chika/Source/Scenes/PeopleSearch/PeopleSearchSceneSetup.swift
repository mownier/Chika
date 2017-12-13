//
//  PeopleSearchSceneSetup.swift
//  Chika
//
//  Created Mounir Ybanez on 12/12/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol PeopleSearchSceneSetup: class {

    func format(cell: UITableViewCell, theme: PeopleSearchSceneTheme, item: PeopleSearchSceneItem?, action: PeopleSearchSceneCellAction?) -> Bool
    func height(for cell: UITableViewCell?, theme: PeopleSearchSceneTheme, item: PeopleSearchSceneItem?, action: PeopleSearchSceneCellAction?) -> CGFloat
}

extension PeopleSearchScene {
    
    class Setup: PeopleSearchSceneSetup {
        
        func format(cell: UITableViewCell, theme: PeopleSearchSceneTheme, item: PeopleSearchSceneItem?, action: PeopleSearchSceneCellAction?) -> Bool {
            guard let cell = cell as? PeopleSearchSceneCell,
                let item = item else {
                    return false
            }
            
            cell.onlineStatusView.isHidden = !item.isActive
            cell.nameLabel.text = item.object.person.name
            cell.action = action
            cell.addButton.isHidden = item.object.isContact
            
            let addButtonTitle: String
            let addButtonBGColor: UIColor
            
            switch item.requestStatus {
            case .none:
                addButtonTitle = "Add Contact"
                addButtonBGColor = theme.addActionBGColor
                
            case .sent:
                addButtonTitle = "Sent"
                addButtonBGColor = theme.addActionOkayBGColor
                
            case .retry:
                addButtonTitle = "Retry"
                addButtonBGColor = theme.addActionFailedBGColor
                
            case .sending:
                addButtonTitle = "Sending"
                addButtonBGColor = theme.addActionActiveBGColor
            
            case .pending:
                addButtonTitle = "Pending"
                addButtonBGColor = theme.addActionPendingBGColor
            }
            
            switch item.requestStatus {
            case .none, .retry, .pending:
                cell.addButton.isUserInteractionEnabled = true
            
            default:
                cell.addButton.isUserInteractionEnabled = false
            }
            
            cell.addButton.setTitle(addButtonTitle, for: .normal)
            cell.addButton.backgroundColor = addButtonBGColor
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return true
        }
        
        func height(for cell: UITableViewCell?, theme: PeopleSearchSceneTheme, item: PeopleSearchSceneItem?, action: PeopleSearchSceneCellAction?) -> CGFloat {
            guard let aCell = cell as? PeopleSearchSceneCell,
                format(cell: aCell, theme: theme, item: item, action: action)  else {
                    return 0
            }
            
            let height = max(aCell.nameLabel.frame.maxY, aCell.avatar.frame.maxY) + min(aCell.nameLabel.frame.origin.y, aCell.avatar.frame.origin.y) + 8
            return height
        }
    }
}
