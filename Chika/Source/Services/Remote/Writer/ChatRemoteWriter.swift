//
//  ChatRemoteWriter.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/7/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

protocol ChatRemoteWriter: class {
    
    func createGroupChat(for participantIDs: [String], callback: @escaping (RemoteWriterResult<Chat>) -> Void)
    func updateTitle(of chatID: String, title: String, callback: @escaping (RemoteWriterResult<(String, String)>) -> Void)
    func addPeople(in chatID: String, persons: [Person], callback: @escaping (RemoteWriterResult<(String, [Person])>) -> Void)
}

class ChatRemoteWriterProvider: ChatRemoteWriter {
    
    var meID: String
    var database: Database
    var chatsQuery: ChatsRemoteQuery
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), chatsQuery: ChatsRemoteQuery = ChatsRemoteQueryProvider()) {
        self.meID = meID
        self.database = database
        self.chatsQuery = chatsQuery
    }
    
    func addPeople(in chatID: String, persons: [Person], callback: @escaping (RemoteWriterResult<(String, [Person])>) -> Void) {
        guard !meID.isEmpty else {
            callback(.err(RemoteWriterError("current user ID is empty")))
            return
        }
        
        guard !chatID.isEmpty else {
            callback(.err(RemoteWriterError("chat ID is empty")))
            return
        }
        
        guard !persons.isEmpty else {
            callback(.err(RemoteWriterError("nothing to add")))
            return
        }
        
        let rootRef = database.reference()
        var participantValues: [String: Any] = [:]
        var inboxValues: [String: Any] = [:]
        for person in persons {
            participantValues["chats/\(chatID)/participants/\(person.id)"] = true
            inboxValues["person:inbox/\(person.id)/\(chatID)/updated:on"] = ServerValue.timestamp()
        }
        rootRef.updateChildValues(participantValues) { error, _ in
            guard error == nil else {
                callback(.err(error!))
                return
            }
            
            rootRef.updateChildValues(inboxValues) { error, _ in
                guard error ==  nil else {
                    callback(.err(error!))
                    return
                }
                
                callback(.ok((chatID, persons)))
            }
        }
    }
    
    func updateTitle(of chatID: String, title: String, callback: @escaping (RemoteWriterResult<(String, String)>) -> Void) {
        guard !meID.isEmpty else {
            callback(.err(RemoteWriterError("current user ID is empty")))
            return
        }
        
        guard !chatID.isEmpty else {
            callback(.err(RemoteWriterError("chat ID is empty")))
            return
        }
        
        guard !title.isEmpty else {
            callback(.err(RemoteWriterError("provided chat title is empty")))
            return
        }
        
        let rootRef = database.reference()
        let values = ["chats/\(chatID)/title" : title]
        rootRef.updateChildValues(values) { error, _ in
            guard error == nil else {
                callback(.err(error!))
                return
            }
            
            callback(.ok((chatID, title)))
        }
    }
    
    func createGroupChat(for participantIDs: [String], callback: @escaping (RemoteWriterResult<Chat>) -> Void) {
        guard !meID.isEmpty else {
            callback(.err(RemoteWriterError("current user ID is empty")))
            return
        }
        
        var personIDs = participantIDs
        personIDs.append(meID)
        personIDs = Array(Set(personIDs))
        
        guard personIDs.count > 2 else {
            callback(.err(RemoteWriterError("not enough participants")))
            return
        }
        
        let chatsQuery = self.chatsQuery
        let rootRef = database.reference()
        let chatsRef = rootRef.child("chats")
        let key = chatsRef.childByAutoId().key
        
        var participants: [String: Bool] = [:]
        for personID in personIDs {
            participants[personID] = true
        }
        
        let newChat: [String: Any] = [
            "created_on": ServerValue.timestamp(),
            "updated_on": ServerValue.timestamp(),
            "id": key,
            "creator": meID,
            "participants": participants
        ]
        
        let values: [String: Any] = [
            "chats/\(key)": newChat
        ]
        
        rootRef.updateChildValues(values) { error, _ in
            guard error == nil else {
                callback(.err(error!))
                return
            }
            
            chatsQuery.getChats(for: [key]) { chats in
                let chats = Array(Set(chats.filter({ $0.id == key })))
                
                guard chats.count == 1 else {
                    callback(.err(RemoteWriterError("chat not created")))
                    return
                }

                callback(.ok(chats[0]))
            }
        }
    }
}
