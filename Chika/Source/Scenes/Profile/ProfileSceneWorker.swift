//
//  ProfileSceneWorker.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/8/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ProfileSceneWorker: class {

    func fetchProfile()
    func listenOnContactRequests()
}

protocol ProfileSceneWorkerOutput: class {
    
    func workerDidFetchProfile(_ person: Person)
    func workerDidFetchProfileWithError(_ error: Error)
    func workerDidReceiveContactRequest()
}

extension ProfileScene {

    class Worker: ProfileSceneWorker {
        
        weak var output: ProfileSceneWorkerOutput?
        var service: PersonRemoteService
        var listener: ContactRemoteListener
        
        init(service: PersonRemoteService = PersonRemoteServiceProvider(), listener: ContactRemoteListener = ContactRemoteListenerProvider()) {
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
        
        func listenOnContactRequests() {
            let _ = listener.listenOnContactRequests { [weak self] _ in
                self?.output?.workerDidReceiveContactRequest()
            }
        }
    }
}
