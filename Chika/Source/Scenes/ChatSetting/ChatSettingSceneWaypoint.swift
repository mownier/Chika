//
//  ChatSettingSceneWaypoint.swift
//  Chika
//
//  Created Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ChatSettingSceneEntryWaypoint: class {
    
    func withChat(_ chat: Chat) -> AppEntryWaypoint
}

extension ChatSettingScene {
    
    class EntryWaypoint: AppEntryWaypoint, ChatSettingSceneEntryWaypoint {
        
        struct Factory {
            
            var scene: ChatSettingSceneFactory
        }
        
        var factory: Factory
        var chat: Chat
        
        init(factory: Factory) {
            self.factory = factory
            self.chat = Chat()
        }
        
        convenience init() {
            let scene = ChatSettingScene.Factory()
            let factory = Factory(scene: scene)
            self.init(factory: factory)
        }
        
        func enter(from parent: UIViewController) -> Bool {
            guard let nav = parent.navigationController else {
                return false
            }
            
            let scene = factory.scene.build(withChat: chat)
            nav.pushViewController(scene, animated: true)
            return true
        }
        
        func withChat(_ aChat: Chat) -> AppEntryWaypoint {
            chat = aChat
            return self
        }
    }
    
    class ExitWaypoint: AppExitWaypoint {
        
        weak var scene: UIViewController?
        
        func exit() -> Bool {
            guard let scene = scene, let nav = scene.navigationController, nav.topViewController == scene else {
                return false
            }
            
            nav.popViewController(animated: true)
            return true
        }
    }
}
