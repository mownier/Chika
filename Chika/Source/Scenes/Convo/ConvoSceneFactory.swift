//
//  ConvoSceneFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ConvoSceneFactory: class {

    func build(chat: Chat) -> ConvoScene
}

extension ConvoScene {
    
    class Factory: ConvoSceneFactory {
        
        func build(chat: Chat) -> ConvoScene {
            let scene = ConvoScene(chat: chat)
            return scene
        }
    }
}
