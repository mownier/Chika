//
//  ChatSettingSceneData.swift
//  Chika
//
//  Created Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import FirebaseAuth

protocol ChatSettingSceneData: class {

    var chat: Chat { get }
    var sectionCount: Int { get }
    var headerItem: ChatSettingSceneHeaderItem { get }
    
    func reuseID(in section: Int, at row: Int) -> String
    func item(in section: Int, at row: Int) -> ChatSettingSceneItem?
    func itemCount(in section: Int) -> Int
    func headerTitle(in section: Int) -> String?
    func toggleShowAction() -> (ChatSettingSceneMemberItem.ShowState, [Int])
    func updateTitle(_ title: String)
    func addParticipants(_ participants: [Person]) -> [Person]
}

extension ChatSettingScene {
    
    class Data: ChatSettingSceneData {
    
        var participantShownLimit: UInt
        var meID: String
        var chat: Chat
        var sections: [[ChatSettingSceneItem]]
        var sectionCount: Int {
            return sections.count
        }
        var headerItem: ChatSettingSceneHeaderItem {
            let creatorName = chat.participants.filter({ $0.id == chat.creator }).first?.displayName ?? ""
            return ChatSettingSceneHeaderItem(creatorName: creatorName, title: chat.title, avatar: "")
        }
    
        init(meID: String = Auth.auth().currentUser?.uid ?? "", chat: Chat, participantShownLimit: UInt) {
            self.participantShownLimit = participantShownLimit
            self.meID = meID
            self.chat = chat
            self.sections = []
            var members: [ChatSettingSceneItem] = chat.participants.filter({ !meID.isEmpty && $0.id != meID }).map({ ChatSettingSceneMemberItem(participant: $0) })
            
            if members.count > participantShownLimit {
                members = Array(members.prefix(Int(participantShownLimit)))
                
                var actionShowItem = ChatSettingSceneMemberItem(participant: Person())
                actionShowItem.action = .showMore
                members.append(actionShowItem)
            }
            
            var actionAddItem = ChatSettingSceneMemberItem(participant: Person())
            actionAddItem.action = .add
            members.insert(actionAddItem, at: 0)
            let options: [ChatSettingSceneItem] = [ ChatSettingSceneOptionItem(label: "Leave") ]
            self.sections.append(members)
            self.sections.append(options)
        }
    
        func reuseID(in section: Int, at row: Int) -> String {
            switch section {
            case 0: return "MemberCell"
            case 1: return "OptionCell"
            default: return ""
            }
        }
        
        func item(in section: Int, at row: Int) -> ChatSettingSceneItem? {
            guard section >= 0, section < sections.count,
                sections[section].count >= 0, row < sections[section].count else {
                return nil
            }
            
            return sections[section][row]
        }
        
        func itemCount(in section: Int) -> Int {
            guard section >= 0, section < sections.count else {
                return 0
            }
            
            return sections[section].count
        }
        
        func headerTitle(in section: Int) -> String? {
            switch section {
            case 0: return chat.participants.isEmpty ? nil : "\(chat.participants.count) MEMBERS"
            case 1: return "OPTIONS"
            default: return nil
            }
        }
        
        func toggleShowAction() -> (ChatSettingSceneMemberItem.ShowState, [Int]) {
            guard let index = sections[0].index(where: { ($0 is ChatSettingSceneMemberItem) && ($0 as! ChatSettingSceneMemberItem).action == .showMore || ($0 as! ChatSettingSceneMemberItem ).action == .showLess }) else {
                return (.none, [])
            }
            
            var item = sections[0][index] as! ChatSettingSceneMemberItem
            let currentAction = item.action
            item.action = item.action == .showLess ? .showMore : .showLess
            sections[0][index] = item
            
            let limit = Int(participantShownLimit)
            let indices: [Int]
            
            if currentAction == .showMore {
                var members: [ChatSettingSceneItem] = chat.participants.filter({ !meID.isEmpty && $0.id != meID }).map({ ChatSettingSceneMemberItem(participant: $0) })
                members = Array(members.suffix(from: limit))
                sections[0].insert(contentsOf: members, at: limit + 1)
                indices = [Int](limit+1...sections[0].count-2)
                
            } else {
                let count = sections[0].count
                indices = [Int](limit+1...count-2)
                sections[0].removeSubrange(limit+1...count-2)
            }

            return (currentAction == .showLess ? .less : .more, indices)
        }
        
        func updateTitle(_ title: String) {
            chat.title = title
        }
        
        func addParticipants(_ participants: [Person]) -> [Person] {
            let added = participants.filter({ !chat.participants.contains($0) && !$0.id.isEmpty && $0.id != meID })
            chat.participants.append(contentsOf: added)
            
            let count = sections[0].count
            if let item = sections[0][count-1] as? ChatSettingSceneMemberItem {
                switch item.action {
                case .showLess:
                    let items: [ChatSettingSceneItem] = added.map({ ChatSettingSceneMemberItem(participant: $0) })
                    sections[0].insert(contentsOf: items, at: count-1)
                
                case .none:
                    let shownCount = count-1
                    if shownCount < Int(participantShownLimit) {
                        for i in 0..<Int(participantShownLimit)-shownCount {
                            guard i >= 0, i < added.count else { continue }
                            let item: ChatSettingSceneItem = ChatSettingSceneMemberItem(participant: added[0])
                            sections[0].insert(item, at: count-1)
                        }
                    }
                    
                    if shownCount+added.count > participantShownLimit {
                        var actionShowItem = ChatSettingSceneMemberItem(participant: Person())
                        actionShowItem.action = .showMore
                        sections[0].append(actionShowItem)
                    }
                
                default:
                    break
                }
            }
            
            return added
        }
    }
}
