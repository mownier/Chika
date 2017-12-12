//
//  ProfileSceneWorker.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/8/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ProfileSceneWorker: class {

    func fetchProfile()
    func listenOnAddedContactRequests()
    func listenOnRemovedContactRequests()
}

protocol ProfileSceneWorkerOutput: class {
    
    func workerDidFetchProfile(_ person: Person)
    func workerDidFetchProfileWithError(_ error: Error)
    func workerDidReceiveContactRequest()
    func workerDidRemoveContactRequest()
}

extension ProfileScene {

    class Worker: ProfileSceneWorker {
        
        weak var output: ProfileSceneWorkerOutput?
        var service: PersonRemoteService
        var listener: ContactRequestRemoteListener
        
        init(service: PersonRemoteService = PersonRemoteServiceProvider(), listener: ContactRequestRemoteListener = ContactRequestRemoteListenerProvider()) {
            self.service = service
            self.listener = listener
        }
        
        func fetchProfile() {
            service.getMyProfile { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidFetchProfileWithError(info)
                
                case .ok(let person):
                    self?.output?.workerDidFetchProfile(person)
                }
            }
        }
        
        func listenOnAddedContactRequests() {
            let _ = listener.listenOnAdded { [weak self] _ in
                self?.output?.workerDidReceiveContactRequest()
            }
        }
        
        func listenOnRemovedContactRequests() {
            let _ = listener.listenOnRemoved { [weak self] _ in
                self?.output?.workerDidRemoveContactRequest()
            }
        }
    }
}
