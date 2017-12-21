//
//  ChatCreatorSceneFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ChatCreatorSceneFactory: class {

    func build(withDefaultParticipants participants: [Person], minimumOtherParticipantLimit limit: UInt, delegate: ChatCreatorSceneDelegate?) -> UIViewController
}

extension ChatCreatorScene {
    
    class Factory: ChatCreatorSceneFactory {
    
        func build(withDefaultParticipants persons: [Person], minimumOtherParticipantLimit limit: UInt, delegate: ChatCreatorSceneDelegate?) -> UIViewController {
            let scene = ChatCreatorScene(participants: persons, limit: limit)
            scene.delegate = delegate
            return scene
        }
    }
}
