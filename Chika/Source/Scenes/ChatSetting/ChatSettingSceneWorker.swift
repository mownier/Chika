//
//  ChatSettingSceneWorker.swift
//  Chika
//
//  Created Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ChatSettingSceneWorker: class {

    func updateTitle(of chatID: String, title: String)
    func addPeople(in chatID: String, people: [Contact])
}

protocol ChatSettingSceneWorkerOutput: class {

    func workerDidUpdateTitle(_ title: String)
    func workerDidUpdateTitleWithError(_ error: Error)
    func workerDidAddPeople(_ people: [Person])
    func worderDidAddPeopleWithError(_ error: Error)
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
        
        func addPeople(in chatID: String, people: [Contact]) {
            chatWriter.addPeople(in: chatID, persons: people.map({ $0.person })) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidUpdateTitleWithError(info)
                    
                case .ok(let (_, people)):
                    self?.output?.workerDidAddPeople(people)
                }
            }
        }
    }
}
