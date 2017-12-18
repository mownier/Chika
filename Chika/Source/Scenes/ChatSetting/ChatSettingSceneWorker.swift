//
//  ChatSettingSceneWorker.swift
//  Chika
//
//  Created Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ChatSettingSceneWorker: class {

    func updateTitle(of chatID: String, title: String)
}

protocol ChatSettingSceneWorkerOutput: class {

    func workerDidUpdateTitle(_ title: String)
    func workerDidUpdateTitleWithError(_ error: Error)
}

extension ChatSettingScene {
    
    class Worker: ChatSettingSceneWorker {
    
        weak var output: ChatSettingSceneWorkerOutput?
    
        var chatWriter: ChatRemoteWriter
        
        init(chatWriter: ChatRemoteWriter = ChatRemoteWriterProvider()) {
            self.chatWriter = chatWriter
        }
        
        func updateTitle(of chatID: String, title: String) {
            chatWriter.updateTitle(of: chatID, title: title) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidUpdateTitleWithError(info)
                
                case .ok(let (_, title)):
                    self?.output?.workerDidUpdateTitle(title)
                }
            }
        }
    }
}
