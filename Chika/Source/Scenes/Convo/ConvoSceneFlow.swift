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
    func goToContactChatSetting(withContact: Contact, delegate: ContactChatSettingSceneDelegate?) -> Bool
}

extension ConvoScene {
    
    class Flow: ConvoSceneFlow {
        
        struct Waypoint {
            
            var chatSetting: ChatSettingSceneEntryWaypoint
            var contactChatSetting: ContactChatSettingSceneEntryWaypoint
        }
        
        weak var scene: UIViewController?
        var waypoint: Waypoint
        
        init(waypoint: Waypoint) {
            self.waypoint = waypoint
        }
        
        convenience init() {
            let chatSetting = ChatSettingScene.EntryWaypoint()
            let contactChatSetting = ContactChatSettingScene.EntryWaypoint()
            let waypoint = Waypoint(chatSetting: chatSetting, contactChatSetting: contactChatSetting)
            self.init(waypoint: waypoint)
        }
        
        func goToChatSetting(withChat chat: Chat, delegate: ChatSettingSceneDelegate?) -> Bool {
            guard scene != nil else {
                return false
            }
            
            return waypoint.chatSetting.withDelegate(delegate).withChat(chat).enter(from: scene!)
        }
        
        func goToContactChatSetting(withContact contact: Contact, delegate: ContactChatSettingSceneDelegate?) -> Bool {
            guard scene != nil else { return false }
            return waypoint.contactChatSetting.withDelegate(delegate).withContact(contact).enter(from: scene!)
        }
    }
}
