//
//  AboutSceneSetup.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol AboutSceneSetup: class {
    
    func formatTitle(in navigationItem: UINavigationItem) -> Bool
    func format(cell: UITableViewCell, theme: AboutSceneTheme, item: AboutSceneItem?) -> Bool
}

extension AboutScene {
    
    class Setup: AboutSceneSetup {
    
        func format(cell: UITableViewCell, theme: AboutSceneTheme, item: AboutSceneItem?) -> Bool {
            guard let item = item else {
                return false
            }
            
            cell.textLabel?.text = item.label
            cell.detailTextLabel?.text = item.content
            
            return false
        }
        
        func formatTitle(in navigationItem: UINavigationItem) -> Bool {
            navigationItem.title = "About"
            return true
        }
    }
}
