//
//  ContactsSceneData.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ContactsSceneData: class {

    var itemCount: Int { get }
    
    func removeAll()
    func append(list: [Person])
    func remove(_ personID: String)
    func item(at index: Int) -> ContactsSceneItem?
    func updateActiveStatus(for personID: String, isActive: Bool) -> Int?
    func updateRequestStatus(for personID: String, status: ContactsSceneItem.RequestStatus) -> Int?
}

extension ContactsScene {
    
    class Data: ContactsSceneData {
        
        var items: [ContactsSceneItem]
        var itemCount: Int {
            return items.count
        }
        
        init() {
            self.items = []
        }
        
        func removeAll() {
            items.removeAll()
        }
        
        func append(list: [Person]) {
            let diff = list.filter { person -> Bool in
                return !items.contains(where: { person.id == $0.person.id })
                }.map({ ContactsSceneItem(person: $0) })
            items.append(contentsOf: diff)
            items.sort(by: { $0.person.name.localizedStandardCompare($1.person.name) == .orderedAscending })
            
        }
        
        func item(at index: Int) -> ContactsSceneItem? {
            guard index >= 0, index < items.count else {
                return nil
            }
            
            return items[index]
        }
        
        func updateActiveStatus(for personID: String, isActive: Bool) -> Int? {
            guard let index = items.index(where: { $0.person.id == personID }) else {
                return nil
            }
            
            items[index].isActive = isActive
            return index
        }
        
        func remove(_ personID: String) {
            guard let index = items.index(where: { $0.person.id == personID }) else {
                return
            }
            
            items.remove(at: index)
        }
        
        func updateRequestStatus(for personID: String, status: ContactsSceneItem.RequestStatus) -> Int? {
            guard let index = items.index(where: { $0.person.id == personID }) else {
                return nil
            }
            
            items[index].requestStatus = status
            return index
        }
    }
}
