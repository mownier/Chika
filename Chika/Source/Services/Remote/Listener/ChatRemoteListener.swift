//
//  ChatRemoteListener.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase

protocol ChatRemoteListener: class {
    
    func listenOnTitleUpdate(for chatID: String, callback: @escaping (RemoteListenerResult<(String, String)>) -> Void) -> Bool
    func unlisteOnTitleUpdate(for chatID: String) -> Bool
    func removeAllTitleUpdateListeners() -> Bool
}

class ChatRemoteListenerProvider: ChatRemoteListener {
    
    var handles: [String: UInt]
    var database: Database
    
    init(database: Database = Database.database()) {
        self.handles = [:]
        self.database = database
    }
    
    func listenOnTitleUpdate(for chatID: String, callback: @escaping (RemoteListenerResult<(String, String)>) -> Void) -> Bool {
        guard !chatID.isEmpty, handles[chatID] == nil else {
            return false
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("chats/\(chatID)/title")
        let handle = ref.observe(.value) { snapshot in
            guard snapshot.exists(), let title = snapshot.value as? String else {
                return
            }
            
            callback(.ok((chatID, title)))
        }
        handles[chatID] = handle
        return true
    }
    
    func unlisteOnTitleUpdate(for chatID: String) -> Bool {
        guard !chatID.isEmpty, let handle = handles[chatID] else {
            return false
        }
        
        let rootRef = database.reference()
        let ref = rootRef.child("chats/\(chatID)/title")
        ref.removeObserver(withHandle: handle)
        return true
    }
    
    func removeAllTitleUpdateListeners() -> Bool {
        let rootRef = database.reference()
        for (chatID, handle) in handles {
            guard !chatID.isEmpty else {
                continue
            }
            
            let ref = rootRef.child("chats/\(chatID)/title")
            ref.removeObserver(withHandle: handle)
        }
        handles.removeAll()
        return true
    }

}
