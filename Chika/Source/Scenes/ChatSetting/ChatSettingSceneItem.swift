//
//  ChatSettingSceneItem.swift
//  Chika
//
//  Created Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ChatSettingSceneItem {

}

struct ChatSettingSceneMemberItem: ChatSettingSceneItem {
    
    var isAddAction: Bool
    var participant: Person
    var isActive: Bool
    
    init(participant: Person, isActive: Bool = false) {
        self.participant = participant
        self.isActive = isActive
        self.isAddAction = false
    }
}

struct ChatSettingSceneOptionItem: ChatSettingSceneItem {
    
    var label: String
    var isDisclosureEnabled: Bool
    
    init(label: String, isDisclosureEnabled: Bool = true) {
        self.label = label
        self.isDisclosureEnabled = isDisclosureEnabled
    }
}

struct ChatSettingSceneHeaderItem {
    
    var creatorName: String
    var title: String
    var avatar: String
    
    init(creatorName: String, title: String, avatar: String) {
        self.creatorName = creatorName
        self.title = title
        self.avatar = avatar
    }
}
