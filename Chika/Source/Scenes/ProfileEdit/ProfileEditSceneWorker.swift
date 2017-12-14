//
//  ProfileEditSceneWorker.swift
//  Chika
//
//  Created Mounir Ybanez on 12/13/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ProfileEditSceneWorker: class {

    func save(newValue: Person, oldValue: Person)
}

protocol ProfileEditSceneWorkerOutput: class {

    func workerDidSaveWithNewValue(_ person: Person)
    func workerDidSaveWithError(_ error: Error)
}

extension ProfileEditScene {
    
    class Worker: ProfileEditSceneWorker {
    
        weak var output: ProfileEditSceneWorkerOutput?
        var service: PersonRemoteService
        
        init(service: PersonRemoteService = PersonRemoteServiceProvider()) {
            self.service = service
        }
        
        func save(newValue: Person, oldValue: Person) {
            service.saveMyInfo(newValue: newValue, oldValue: oldValue) { [weak self] result in
                switch result {
                case .err(let info):
                    self?.output?.workerDidSaveWithError(info)
                
                case .ok(let person):
                    self?.output?.workerDidSaveWithNewValue(person)
                }
            }
        }
    }
}
