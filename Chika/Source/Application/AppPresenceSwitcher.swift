//
//  AppPresenceSwitcher.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseAuth

protocol AppPresenceSwitcher: class {
    
    func setActive()
    func setInactive()
}

extension AppDelegate {
    
    class PresenceSwitcher: AppPresenceSwitcher {
        
        var factory: PresenceRemoteWriterFactory
        
        init(factory: PresenceRemoteWriterFactory) {
            self.factory = factory
        }
        
        convenience init() {
            let factory = PresenceRemoteWriterProvider.Factory()
            self.init(factory: factory)
        }
        
        func setActive() {
            let writer = factory.build()
            writer.makeOnline { _ in }
        }
        
        func setInactive() {
            let writer = factory.build()
            writer.makeOffline { _ in }
        }
    }
}
