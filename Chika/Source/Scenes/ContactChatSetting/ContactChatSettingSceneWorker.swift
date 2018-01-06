//
//  ContactChatSettingSceneWorker.swift
//  Chika
//
//  Created Mounir Ybanez on 12/19/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ContactChatSettingSceneWorker: class {

    func updateTitle(of chatID: String, title: String)
}

protocol ContactChatSettingSceneWorkerOutput: class {

    func workerDidUpdateTitle(_ title: String)
    func workerDidUpdateTitleWithError(_ error: Swift.Error)
}

extension ContactChatSettingScene {
    
    class Worker: ContactChatSettingSceneWorker {
    
        weak var output: ContactChatSettingSceneWorkerOutput?
        
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
