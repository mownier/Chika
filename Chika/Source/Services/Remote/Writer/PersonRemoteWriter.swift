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

    func saveInfo(newValue: Person, oldValue: Person, callback: @escaping (Error?) -> Void)
}

class PersonRemoteWriterProvider: PersonRemoteWriter {
    
    var meID: String
    var database: Database
    
    init(meID: String = Auth.auth().currentUser?.uid ?? "", database: Database = Database.database()) {
        self.meID = meID
        self.database = database
    }
    
    func saveInfo(newValue: Person, oldValue: Person, callback: @escaping (Error?) -> Void) {
        let meID = self.meID
        guard !meID.isEmpty else {
            callback(RemoteWriterError("current user ID is empty"))
            return
        }
        
        let rootRef = database.reference()
        
        if newValue.name != oldValue.name {
            let ref = rootRef.child("person:name")
            let query = ref.queryOrderedByKey().queryEqual(toValue: newValue.name)
            query.observeSingleEvent(of: .value, with: { snapshot in
                guard !snapshot.exists() else {
                    callback(RemoteWriterError("name is already taken"))
                    return
                }
                
                var values: [String: Any] = [
                    "persons/\(meID)/name": newValue.name,
                    "persons:search/\(meID)/name": newValue.name.lowercased(),
                    "person:name/\(newValue.name)": meID,
                    "person:name/\(oldValue.name)": NSNull()
                ]
                
                if newValue.displayName != oldValue.displayName {
                    values["persons/\(meID)/display:name"] = newValue.displayName
                    values["persons:search/\(meID)/display:name"] = newValue.displayName.lowercased()
                }
                
                rootRef.updateChildValues(values, withCompletionBlock: { error, _ in
                    callback(error)
                })
            })
            
        } else if newValue.displayName != oldValue.displayName {
            let values: [String: Any] = [
                "persons/\(meID)/display:name": newValue.displayName,
                "persons:search/\(meID)/display:name": newValue.displayName.lowercased()
            ]
            
            rootRef.updateChildValues(values, withCompletionBlock: { error, _ in
                callback(error)
            })
            
        } else {
            callback(RemoteWriterError("nothing to update"))
        }
    }
}
