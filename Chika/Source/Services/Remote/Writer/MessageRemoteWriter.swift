//
//  MessageRemoteWriter.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/25/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

protocol MessageRemoteWriter: class {

    func postMessage(for chatID: String, participantIDs: [String], content: String, completion: @escaping (RemoteWriterResult<Message>) -> Void)
}

class MessageRemoteWriterProvider: MessageRemoteWriter {
    
    var database: Database
    var meID: String
    var messagesQuery: MessagesRemoteQuery
    
    init(database: Database = Database.database(), meID: String = Auth.auth().currentUser?.uid ?? "", messagesQuery: MessagesRemoteQuery = MessagesRemoteQueryProvider()) {
        self.database = database
        self.meID = meID
        self.messagesQuery = messagesQuery
    }
    
    func postMessage(for chatID: String, participantIDs: [String], content: String, completion: @escaping (RemoteWriterResult<Message>) -> Void) {
        guard !chatID.isEmpty, !content.isEmpty, !meID.isEmpty else {
            completion(.err(RemoteWriterError("chat ID, content, and author ID should not be empty")))
            return
        }
        
        var personIDs = participantIDs
        if !personIDs.contains(meID) {
            personIDs.append(meID)
        }
        guard personIDs.count > 1 else {
            completion(.err(RemoteWriterError("participantIDs should contain more than 1")))
            return
        }
        
        let rootRef = database.reference()
        let key = rootRef.child("messages").childByAutoId().key
        let messagesQuery = self.messagesQuery
        
        let createdOn = ServerValue.timestamp()
        let message: [String: Any] = [
            "id": key,
            "content": content,
            "author": meID,
            "created_on": createdOn
        ]
        var updates: [String: Any] = [
            "messages/\(key)": message,
            "chat:messages/\(chatID)/\(key)": ["created_on": createdOn]
        ]
        
        for personID in personIDs {
            updates["person:inbox/\(personID)/\(chatID)"] = ["updated_on": createdOn]
        }
        
        rootRef.updateChildValues(updates) { error, _ in
            guard error == nil else {
                completion(.err(RemoteWriterError(error!.localizedDescription)))
                return
            }
            
            messagesQuery.getMessages(for: [key]) { messages in
                guard messages.count == 1 else {
                    completion(.err(RemoteWriterError("succesfully written a message but failed to fetch the new message")))
                    return
                }
                
                completion(.ok(messages[0]))
            }
        }
    }
}
