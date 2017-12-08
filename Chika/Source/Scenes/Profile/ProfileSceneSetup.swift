//
//  ProfileSceneSetup.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/8/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ProfileSceneSetup: class {
    
    func format(cell: UITableViewCell, theme: ProfileSceneTheme, item: ProfileSceneItem?) -> Bool
}

extension ProfileScene {
    
    class Setup: ProfileSceneSetup {
        
        func format(cell: UITableViewCell, theme: ProfileSceneTheme, item: ProfileSceneItem?) -> Bool {
            guard let item = item else {
                return false
            }
            
            cell.textLabel?.textColor = theme.labelTextColor
            cell.accessoryType = .none
            cell.textLabel?.text = item.label
            cell.detailTextLabel?.text = item.content
            
            if item.content.isEmpty  {
                cell.accessoryType = .disclosureIndicator
            }
            
            if item.label.lowercased() == "sign out" {
                cell.textLabel?.textColor = theme.destructiveTextColor
            }
            
            return false
        }
    }
}
