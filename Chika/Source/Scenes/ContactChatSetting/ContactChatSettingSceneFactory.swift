//
//  ContactChatSettingSceneFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/19/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactChatSettingSceneFactory: class {

    func build(withContact: Contact, delegate: ContactChatSettingSceneDelegate?) -> UIViewController
}

extension ContactChatSettingScene {
    
    class Factory: ContactChatSettingSceneFactory {
    
        func build(withContact contact: Contact, delegate: ContactChatSettingSceneDelegate?) -> UIViewController {
            let scene = ContactChatSettingScene(contact: contact)
            scene.delegate = delegate
            return scene
        }
    }
}
