//
//  PresenceRemoteWriter.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/2/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

protocol PresenceRemoteWriter: class {

    func makeOnline(callback: @escaping (RemoteWriterResult<String>) -> Void)
    func makeOffline(callback: @escaping (RemoteWriterResult<String>) -> Void)
}

protocol PresenceRemoteWriterFactory: class {

    func build() -> PresenceRemoteWriter
}

class PresenceRemoteWriterProvider: PresenceRemoteWriter {
    
    class Factory: PresenceRemoteWriterFactory {
        
        func build() -> PresenceRemoteWriter {
            return PresenceRemoteWriterProvider()
        }
    }
    
    var meID: String
    var database: Database
    var connectedHandle: DatabaseHandle?
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database()) {
        self.meID = meID
        self.database = database
    }
    
    func makeOnline(callback: @escaping (RemoteWriterResult<String>) -> Void) {
        let rootRef = database.reference()
        let connectedRef = rootRef.child(".info/connected")
        let meID = self.meID
        
        connectedHandle = connectedRef.observe(.value) { snapshot in
            guard let connected = snapshot.value as? Bool, connected else {
                callback(.err(RemoteWriterError("not connected")))
                return
            }
            
            let ref = rootRef.child("person:presence/\(meID)")
            ref.onDisconnectSetValue(["is:active": false, "active:on": ServerValue.timestamp()])
            ref.setValue(["is:active": true, "active:on": ServerValue.timestamp()])
            
            callback(.ok("OK"))
        }
    }
    
    func makeOffline(callback: @escaping (RemoteWriterResult<String>) -> Void) {
        let rootRef = database.reference()
        let ref = rootRef.child("person:presence/\(meID)")
        let value: [String: Any] = ["is:active": false, "active:on": ServerValue.timestamp()]
        
        ref.setValue(value) { error, _ in
            guard error == nil else {
                callback(.err(RemoteWriterError(error!.localizedDescription)))
                return
            }
            
            callback(.ok("OK"))
        }
        
        guard connectedHandle != nil else {
            return
        }
        
        let connectedRef = rootRef.child(".info/connected")
        connectedRef.removeObserver(withHandle: connectedHandle!)
    }
}
