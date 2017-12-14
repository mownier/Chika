//
//  SupportSceneSetup.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol SupportSceneSetup: class {
    
    func formatTitle(in navigationItem: UINavigationItem) -> Bool
    func format(cell: UITableViewCell, item: SupportSceneItem?) -> Bool
}

extension SupportScene {
    
    class Setup: SupportSceneSetup {
    
        func formatTitle(in navigationItem: UINavigationItem) -> Bool {
            navigationItem.title = "Help & Feedback"
            return true
        }
        
        func format(cell: UITableViewCell, item: SupportSceneItem?) -> Bool {
            guard let item = item else {
                return false
            }
            
            cell.textLabel?.text = item.label
            
            return true
        }
    }
}
