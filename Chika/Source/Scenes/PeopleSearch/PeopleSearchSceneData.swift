//
//  PeopleSearchSceneData.swift
//  Chika
//
//  Created Mounir Ybanez on 12/12/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol PeopleSearchSceneData: class {

    var itemCount: Int { get }
    
    func removeAll()
    func item(at row: Int) -> PeopleSearchSceneItem?
    func item(for personID: String) -> PeopleSearchSceneItem?
    func appendItems(_ objects: [PersonSearchObject])
    func updateRequestStatus(for personID: String, status: PeopleSearchSceneItem.RequestStatus) -> Int?
    func updateActiveStatus(for personID: String, isActive: Bool) -> Int?
    func updateAsAddedContact(person: Person, chat: Chat) -> Int?
    func updateAsRemovedContact(for personID: String) -> Int?
    func updateOnReceivedContactRequest(from personID: String) -> Int?
    func updateOnIgnoredContactRequest(by personID: String) -> Int?
}

extension PeopleSearchScene {
    
    class Data: PeopleSearchSceneData {
        
        var items: [PeopleSearchSceneItem] = []
        var itemCount: Int {
            return items.count
        }
        
        func removeAll() {
            items.removeAll()
        }
        
        func item(at row: Int) -> PeopleSearchSceneItem? {
            guard row >= 0, row < items.count else { return nil }
            return items[row]
        }
        
        func item(for personID: String) -> PeopleSearchSceneItem? {
            guard let index = items.index(where: { $0.object.person.id == personID }) else {
                return nil
            }
            
            return items[index]
        }
        
        func appendItems(_ objects: [PersonSearchObject]) {
            let objects: [PeopleSearchSceneItem] = Array(Set(objects)).map({ PeopleSearchSceneItem(object: $0) })
            items.append(contentsOf: objects)
        }
        
        func updateRequestStatus(for personID: String, status: PeopleSearchSceneItem.RequestStatus) -> Int? {
            guard let index = items.index(where: { $0.object.person.id == personID }) else {
                return nil
            }
            
            items[index].requestStatus = status
            return index
        }
        
        func updateActiveStatus(for personID: String, isActive: Bool) -> Int? {
            guard let index = items.index(where: { $0.object.person.id == personID }) else {
                return nil
            }
            
            items[index].isActive = isActive
            return index
        }
        
        func updateAsAddedContact(person: Person, chat: Chat) -> Int? {
            guard let index = items.index(where: { $0.object.person.id == person.id }) else {
                return nil
            }
            
            items[index].requestStatus = .none
            items[index].object.person = person
            items[index].object.chat = chat
            items[index].object.isContact = true
            items[index].object.isRequested = false
            items[index].object.isPending = false
            return index
        }
        
        func updateAsRemovedContact(for personID: String) -> Int? {
            guard let index = items.index(where: { $0.object.person.id == personID }) else {
                return nil
            }
            
            items[index].requestStatus = .none
            items[index].isActive = false
            items[index].object.chat = Chat()
            items[index].object.isContact = false
            items[index].object.isRequested = false
            items[index].object.isPending = false
            return index
        }
        
        func updateOnReceivedContactRequest(from personID: String) -> Int? {
            guard let index = items.index(where: { $0.object.person.id == personID }) else {
                return nil
            }
            
            items[index].object.isRequested = false
            items[index].object.isPending = true
            items[index].requestStatus = .pending
            return index
        }
        
        func updateOnIgnoredContactRequest(by personID: String) -> Int? {
            guard let index = items.index(where: { $0.object.person.id == personID }) else {
                return nil
            }
            
            items[index].object.isPending = false
            items[index].object.isRequested = false
            items[index].requestStatus = .none
            return index
        }
    }
}
