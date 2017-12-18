//
//  ContactSelectorSceneData.swift
//  Chika
//
//  Created Mounir Ybanez on 12/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ContactSelectorSceneData: class {

    var itemCount: Int { get }
    var selectedContacts: [Contact] { get }
    
    func item(at row: Int) -> ContactSelectorSceneItem?
    func appendContacts(_ contacts: [Contact])
    func toggleSelectedStatus(at row: Int)
    func removeAll()
}

extension ContactSelectorScene {
    
    class Data: ContactSelectorSceneData {
    
        var items: [ContactSelectorSceneItem]
        var itemCount: Int {
            return items.count
        }
        var selectedContacts: [Contact] {
            return items.filter({ $0.isSelected }).map({ $0.contact })
        }
    
        init() {
            items = []
        }
    
        func item(at row: Int) -> ContactSelectorSceneItem? {
            guard row >= 0, row < items.count else { return nil }
            return items[row]
        }
        
        func appendContacts(_ contacts: [Contact]) {
            let diff = contacts.filter { contact -> Bool in
                return !items.contains(where: { contact.person.id == $0.contact.person.id })
                }.map({ ContactSelectorSceneItem(contact: $0) })
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
