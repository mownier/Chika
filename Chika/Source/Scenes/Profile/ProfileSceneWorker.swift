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
    func signOut()
}

protocol ProfileSceneWorkerOutput: class {
    
    func workerDidFetchProfile(_ person: Person)
    func workerDidFetchProfileWithError(_ error: Error)
    func workerDidReceiveContactRequest()
    func workerDidRemoveContactRequest()
    func workerDidSignOut()
    func workerDidSignOutWithError(_ error: Error)
}

extension ProfileScene {

    class Worker: ProfileSceneWorker {
        
        struct Service {
            
            var person: PersonRemoteService
            var auth: AuthRemoteService
        }
        
        weak var output: ProfileSceneWorkerOutput?
        var service: Service
        var listener: ContactRequestRemoteListener
        
        init(service: Service, listener: ContactRequestRemoteListener) {
            self.service = service
            self.listener = listener
        }
        
        convenience init() {
            let person = PersonRemoteServiceProvider()
            let auth = AuthRemoteServiceProvider()
            let service = Service(person: person, auth: auth)
            let listener = ContactRequestRemoteListenerProvider()
            self.init(service: service, listener: listener)
        }
        
        func fetchProfile() {
            service.person.getMyProfile { [weak self] result in
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
        
        func signOut() {
            service.auth.signOut { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidSignOutWithError(info)
                
                case .ok:
                    self?.output?.workerDidSignOut()
                }
            }
        }
    }
}
