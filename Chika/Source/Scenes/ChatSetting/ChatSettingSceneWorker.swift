//
//  ChatSettingSceneWorker.swift
//  Chika
//
//  Created Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ChatSettingSceneWorker: class {

}

protocol ChatSettingSceneWorkerOutput: class {

}

extension ChatSettingScene {
    
    class Worker: ChatSettingSceneWorker {
    
        weak var output: ChatSettingSceneWorkerOutput?
    }
}
