//
//  ProfileSceneData.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/8/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ProfileSceneData: class {
    
    var contactRequestCount: UInt { set get }
    var person: Person { get }
    var itemCount: Int { get }
    var items: [ProfileSceneItem] { get }
    
    func item(at index: Int) -> ProfileSceneItem?
    func updatePerson(_ person: Person)
}

extension ProfileScene {
    
    class Data: ProfileSceneData {
        
        var contactRequestCount: UInt
        var items: [ProfileSceneItem]
        var itemCount: Int {
            return items.count
        }
        var person: Person {
            didSet {
                items.removeAll()
                
                var item = ProfileSceneItem()
                
                item.label = "Display Name"
                item.content = person.displayName
                items.append(item)
                
                item.label = "Chika Name"
                item.content = person.name
                items.append(item)
                
                item.label = "Email"
                item.content = person.email
                item.isDisclosureEnabled = true
                items.append(item)
                
                item.label = "Change password"
                item.content = ""
                items.append(item)
                
                item.label = "Help & Feedback"
                item.content = ""
                items.append(item)
                
                item.label = "About"
                item.content = ""
                items.append(item)
                
                item.label = "Sign Out"
                item.content = ""
                items.append(item)
            }
        }
        
        init() {
            contactRequestCount = 0
            items = []
            person = Person()
        }
        
        func item(at index: Int) -> ProfileSceneItem? {
            guard index >= 0, index < items.count else {
                return nil
            }
            
            return items[index]
        }
        
        func updatePerson(_ person: Person) {
            self.person = person
        }
    }
}
