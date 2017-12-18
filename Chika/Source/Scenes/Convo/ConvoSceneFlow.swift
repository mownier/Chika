//
//  ConvoSceneFlow.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ConvoSceneFlow: class {

    func goToChatSetting(withChat: Chat, delegate: ChatSettingSceneDelegate?) -> Bool
}

extension ConvoScene {
    
    class Flow: ConvoSceneFlow {
        
        struct Waypoint {
            
            var chatSetting: ChatSettingSceneEntryWaypoint
        }
        
        weak var scene: UIViewController?
        var waypoint: Waypoint
        
        init(waypoint: Waypoint) {
            self.waypoint = waypoint
        }
        
        convenience init() {
            let chatSetting = ChatSettingScene.EntryWaypoint()
            let waypoint = Waypoint(chatSetting: chatSetting)
            self.init(waypoint: waypoint)
        }
        
        func goToChatSetting(withChat chat: Chat, delegate: ChatSettingSceneDelegate?) -> Bool {
            guard scene != nil else {
                return false
            }
            
            return waypoint.chatSetting.withDelegate(delegate).withChat(chat).enter(from: scene!)
        }
    }
}
