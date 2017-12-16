//
//  ChatSettingSceneFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ChatSettingSceneFactory: class {

    func build(withChat chat: Chat, participantShownLimit limit: UInt) -> UIViewController
}

extension ChatSettingScene {
    
    class Factory: ChatSettingSceneFactory {
    
        func build(withChat chat: Chat, participantShownLimit limit: UInt) -> UIViewController {
            let scene = ChatSettingScene(chat: chat, participantShownLimit: limit)
            return scene
        }
    }
}
