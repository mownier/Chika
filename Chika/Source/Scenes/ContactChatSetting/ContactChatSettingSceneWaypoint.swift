//
//  ContactChatSettingSceneWaypoint.swift
//  Chika
//
//  Created Mounir Ybanez on 12/19/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactChatSettingSceneEntryWaypoint: class {
    
    func withContact(_ aContact: Contact) -> AppEntryWaypoint
    func withDelegate(_ aDelegate: ContactChatSettingSceneDelegate?) -> ContactChatSettingSceneEntryWaypoint
}

extension ContactChatSettingScene {
    
    class EntryWaypoint: AppEntryWaypoint, ContactChatSettingSceneEntryWaypoint {
        
        struct Factory {
            
            var scene: ContactChatSettingSceneFactory
        }
        
        weak var delegate: ContactChatSettingSceneDelegate?
        var contact: Contact
        var factory: Factory
        
        init(factory: Factory) {
            self.factory = factory
            self.contact = Contact()
        }
        
        convenience init() {
            let scene = ContactChatSettingScene.Factory()
            let factory = Factory(scene: scene)
            self.init(factory: factory)
        }
        
        func enter(from parent: UIViewController) -> Bool {
            guard let nav = parent.navigationController else { return false }
            let scene = factory.scene.build(withContact: contact, delegate: delegate)
            nav.pushViewController(scene, animated: true)
            delegate = nil
            return true
        }
        
        func withContact(_ aContact: Contact) -> AppEntryWaypoint {
            contact = aContact
            return self
        }
        
        func withDelegate(_ aDelegate: ContactChatSettingSceneDelegate?) -> ContactChatSettingSceneEntryWaypoint {
            delegate = aDelegate
            return self
        }
    }
    
    class ExitWaypoint: AppExitWaypoint {
        
        weak var scene: UIViewController?
        
        func exit() -> Bool {
            guard let nav = scene?.navigationController, nav.topViewController == scene else {
                return false
            }
            
            let _ = nav.popViewController(animated: true)
            return true
        }
    }
}
