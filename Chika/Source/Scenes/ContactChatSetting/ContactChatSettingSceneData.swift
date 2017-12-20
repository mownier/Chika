//
//  ContactChatSettingSceneData.swift
//  Chika
//
//  Created Mounir Ybanez on 12/19/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ContactChatSettingSceneData: class {

    var item: ContactChatSettingSceneItem { get }
    
    func updateTitle(_ title: String)
}

extension ContactChatSettingScene {
    
    class Data: ContactChatSettingSceneData {
    
        var item: ContactChatSettingSceneItem
    
        init(contact: Contact) {
            self.item = ContactChatSettingSceneItem(contact: contact)
        }
        
        func updateTitle(_ title: String) {
            item.contact.chat.title = title
        }
    }
}
