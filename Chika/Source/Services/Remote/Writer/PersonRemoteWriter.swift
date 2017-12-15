//
//  PersonRemoteWriter.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/13/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase

protocol PersonRemoteWriter: class {

    func add(email: String, id: String, callback: @escaping (RemoteWriterResult<String>) -> Void)
    func saveInfo(newValue: Person, oldValue: Person, callback: @escaping (RemoteWriterResult<String>) -> Void)
}

class PersonRemoteWriterProvider: PersonRemoteWriter {
    
    var meID: String
    var database: Database
    var emailValidator: EmailValidator
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database(), emailValidator: EmailValidator = EmailValidatorProvider()) {
        self.meID = meID
        self.database = database
        self.emailValidator = emailValidator
    }
    
    func add(email: String, id: String, callback: @escaping (RemoteWriterResult<String>) -> Void) {
        guard !email.isEmpty else {
            callback(.err(RemoteWriterError("email is empty")))
            return
        }
        
        guard emailValidator.isValid(email) else {
            callback(.err(RemoteWriterError("email is badly formatted")))
            return
        }
        
        guard !id.isEmpty else {
            callback(.err(RemoteWriterError("person ID is empty")))
            return
        }
        
        var personsSearchValue: [String: String] = [:]
        var personValue = ["id": id]
        if let displayName = email.split(separator: "@").first, !displayName.isEmpty {
            personValue["display:name"] = String(displayName)
            personsSearchValue["display:name"] = String(displayName)
            personsSearchValue["email"] = String(displayName)
        }
        
        var values: [String: Any] = [
            "persons/\(id)": personValue,
            "person:email/\(id)/email": email,
            "person:contacts/\(id)/contact:default:id/chat": "chat:default:id",
            "person:inbox/\(id)/chat:default:id/updated:on": 0
        ]
        if !personsSearchValue.isEmpty {
            values["persons:search/\(id)"] = personsSearchValue
        }
        
        let ref = database.reference()
        ref.updateChildValues(values) { error, _ in
            guard error == nil else {
                callback(.err(error!))
                return
            }
            
            callback(.ok("OK"))
        }
    }
    
    func saveInfo(newValue: Person, oldValue: Person, callback: @escaping (RemoteWriterResult<String>) -> Void) {
        let meID = self.meID
        guard !meID.isEmpty else {
            callback(.err(RemoteWriterError("current user ID is empty")))
            return
        }
        
        let rootRef = database.reference()
        
        if newValue.name != oldValue.name {
            let ref = rootRef.child("person:name")
            let query = ref.queryOrderedByKey().queryEqual(toValue: newValue.name)
            query.observeSingleEvent(of: .value, with: { snapshot in
                guard !snapshot.exists() else {
                    callback(.err(RemoteWriterError("name is already taken")))
                    return
                }
                
                var values: [String: Any] = [
                    "persons/\(meID)/name": newValue.name,
                    "persons:search/\(meID)/name": newValue.name.lowercased(),
                    "person:name/\(newValue.name)": meID
                ]
                
                if !oldValue.name.isEmpty {
                    values["person:name/\(oldValue.name)"] = NSNull()
                }
                
                if newValue.displayName != oldValue.displayName {
                    values["persons/\(meID)/display:name"] = newValue.displayName
                    values["persons:search/\(meID)/display:name"] = newValue.displayName.lowercased()
                }
                
                rootRef.updateChildValues(values, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        callback(.err(error!))
                        return
                    }
                    
                    callback(.ok("OK"))
                })
            })
            
        } else if newValue.displayName != oldValue.displayName {
            let values: [String: Any] = [
                "persons/\(meID)/display:name": newValue.displayName,
                "persons:search/\(meID)/display:name": newValue.displayName.lowercased()
            ]
            
            rootRef.updateChildValues(values, withCompletionBlock: { error, _ in
                guard error == nil else {
                    callback(.err(error!))
                    return
                }
                
                callback(.ok("OK"))
            })
            
        } else {
            callback(.err(RemoteWriterError("nothing to update")))
        }
    }
}
