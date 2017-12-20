//
//  ContactChatSettingSceneSetup.swift
//  Chika
//
//  Created Mounir Ybanez on 12/19/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactChatSettingSceneSetup: class {
    
    func formatTitle(in navigationItem: UINavigationItem) -> Bool
}

extension ContactChatSettingScene {
    
    class Setup: ContactChatSettingSceneSetup {
    
        func formatTitle(in navigationItem: UINavigationItem) -> Bool {
            navigationItem.title = "Chat Setting"
            return true
        }
    }
}
