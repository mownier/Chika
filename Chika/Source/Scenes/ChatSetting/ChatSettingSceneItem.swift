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
    
    enum Action {
        
        case none, add, showLess, showMore
    }
    
    enum ShowState {
        
        case none, less, more
    }
    
    var action: Action
    var participant: Person
    var isActive: Bool
    var text: String {
        switch action {
        case .none: return participant.displayName
        case .add: return "Add People"
        case .showLess: return "Show less"
        case .showMore: return "Show more"
        }
    }
    
    init(participant: Person, isActive: Bool = false) {
        self.participant = participant
        self.isActive = isActive
        self.action = .none
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
