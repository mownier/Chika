//
//  ContactChatSettingSceneFlow.swift
//  Chika
//
//  Created Mounir Ybanez on 12/19/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactChatSettingSceneFlow: class {

    func goToChatCreator(withDefaultParticipants persons: [Person], minimumOtherParticipantLimit limit: UInt, delegate: ChatCreatorSceneDelegate?) -> Bool
}

extension ContactChatSettingScene {
    
    class Flow: ContactChatSettingSceneFlow {
    
        struct Waypoint {
    
            var chatCreator: ChatCreatorSceneEntryWaypoint
        }
    
        weak var scene: UIViewController?
        weak var delegate: ChatCreatorSceneDelegate?
        var waypoint: Waypoint
        
        init(waypoint: Waypoint) {
            self.waypoint = waypoint
        }
    
        convenience init() {
            let chatCreator = ChatCreatorScene.EntryWaypoint()
            let waypoint = Waypoint(chatCreator: chatCreator)
            self.init(waypoint: waypoint)
        }
        
        func goToChatCreator(withDefaultParticipants persons: [Person], minimumOtherParticipantLimit limit: UInt, delegate: ChatCreatorSceneDelegate?) -> Bool {
            guard let scene = scene else { return false }
            return waypoint.chatCreator.withDelegate(delegate).withMinimumOtherParticipantLimit(limit).withDefaultParticipants(persons).enter(from: scene)
        }
    }
}
