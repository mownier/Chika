//
//  ChatCreatorSceneData.swift
//  Chika
//
//  Created Mounir Ybanez on 12/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ChatCreatorSceneData: class {

    var itemCount: Int { get }
    var selectedParticipants: [Person] { get }
    
    func item(at row: Int) -> ChatCreatorSceneItem?
    func appendContacts(_ contacts: [Contact])
    func toggleSelectedStatus(at row: Int)
    func removeAll()
}

extension ChatCreatorScene {
    
    class Data: ChatCreatorSceneData {
    
        var participants: [Person]
        var limit: UInt
        var items: [ChatCreatorSceneItem]
        var itemCount: Int {
            return items.count
        }
        var selectedParticipants: [Person] {
            var selected = items.filter({ $0.isSelected }).map({ $0.contact.person })
            selected.append(contentsOf: participants)
            return selected
        }
    
        init(participants: [Person], limit: UInt) {
            self.items = []
            self.participants = participants
            self.limit = limit
        }
    
        func item(at row: Int) -> ChatCreatorSceneItem? {
            guard row >= 0, row < items.count else { return nil }
            return items[row]
        }
        
        func appendContacts(_ contacts: [Contact]) {
            let diff = contacts.filter { contact -> Bool in
                return !items.contains(where: { contact.person.id == $0.contact.person.id })
                }.map({ ChatCreatorSceneItem(contact: $0) }).filter({ !participants.contains($0.contact.person) })
            
            items.append(contentsOf: diff)
            items.sort(by: { $0.contact.person.displayName.localizedStandardCompare($1.contact.person.displayName) == .orderedAscending })
        }
        
        func toggleSelectedStatus(at row: Int) {
            guard row >= 0, row < items.count else { return }
            items[row].isSelected = !items[row].isSelected
        }
        
        func removeAll() {
            items.removeAll()
        }
    }
}
