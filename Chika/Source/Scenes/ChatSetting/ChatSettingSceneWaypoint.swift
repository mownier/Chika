//
//  ChatSettingSceneWaypoint.swift
//  Chika
//
//  Created Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

protocol ChatSettingSceneEntryWaypoint: class {
    
    func withChat(_ chat: Chat) -> TNCore.EntryWaypoint
    func withParticipantShownLimit(_ limit: UInt) -> ChatSettingSceneEntryWaypoint
    func withDelegate(_ delegate: ChatSettingSceneDelegate?) -> ChatSettingSceneEntryWaypoint
}

extension ChatSettingScene {
    
    class EntryWaypoint: TNCore.EntryWaypoint, ChatSettingSceneEntryWaypoint {
        
        struct Factory {
            
            var scene: ChatSettingSceneFactory
        }
        
        var factory: Factory
        var chat: Chat
        var limit: UInt
        weak var delegate: ChatSettingSceneDelegate?
        
        init(factory: Factory) {
            self.factory = factory
            self.chat = Chat()
            self.limit = 4
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
            
            let scene = factory.scene.build(withChat: chat, participantShownLimit: limit, delegate: delegate)
            nav.pushViewController(scene, animated: true)
            delegate = nil
            return true
        }
        
        func withChat(_ aChat: Chat) -> TNCore.EntryWaypoint {
            chat = aChat
            return self
        }
        
        func withParticipantShownLimit(_ aLimit: UInt) -> ChatSettingSceneEntryWaypoint {
            limit = aLimit
            return self
        }
        
        func withDelegate(_ aDelegate: ChatSettingSceneDelegate?) -> ChatSettingSceneEntryWaypoint {
            delegate = aDelegate
            return self
        }
    }
    
    class ExitWaypoint: TNCore.ExitWaypoint {
        
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
