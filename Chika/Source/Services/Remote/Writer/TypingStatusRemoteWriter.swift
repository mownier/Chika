//
//  TypingStatusRemoteWriter.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/29/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

protocol TypingStatusRemoteWriter: class {

    func changeTypingStatus(_ isTyping: Bool, for chatID: String, completion: @escaping (RemoteWriterResult<String>) -> Void)
}

class TypingStatusRemoteWriterProvider: TypingStatusRemoteWriter {
    
    var database: Database
    var meID: String
    
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database()) {
        self.meID = meID
        self.database = database
    }
    
    func changeTypingStatus(_ isTyping: Bool, for chatID: String, completion: @escaping (RemoteWriterResult<String>) -> Void) {
        guard !chatID.isEmpty else {
            completion(.err(RemoteWriterError("chat ID is empty")))
            return
        }
        
        let meID = self.meID
        let rootRef = database.reference()
        let ref = rootRef.child("chat:typing:status/\(chatID)/\(meID)")
     
        ref.setValue(isTyping) { error, reference in
            guard error == nil else {
                completion(.err(RemoteWriterError(error!.localizedDescription)))
                return
            }
            
            completion(.ok("OK"))
        }
    }
}
