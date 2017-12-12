//
//  ContactRequestSceneData.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ContactRequestSceneData: class {

    var sectionCount: Int { get }
    
    func itemCount(in section: Int) -> Int
    func item(in section: Int, at row: Int) -> ContactRequestSceneItem?
    func appendSentRequests(_ requests: [Contact.Request])
    func appendPendingRequests(_ requests: [Contact.Request])
    func headerTitle(in section: Int) -> String?
    func updateMessageShown(in section: Int, at row: Int, isShown: Bool)
    func updateAcceptStatus(for id: String, status: ContactRequestSceneItem.ActionStatus)
    func updateIgnoreStatus(for id: String, status: ContactRequestSceneItem.ActionStatus)
    func updateRevokeStatus(for id: String, status: ContactRequestSceneItem.ActionStatus)
    func updateForRemovedRequest(withID id: String)
    func sectionCategory(for section: Int) -> ContactRequestSceneItem.SectionCategory
}

extension ContactRequestScene {
    
    class Data: ContactRequestSceneData {
        
        var sent: [ContactRequestSceneItem]
        var pending: [ContactRequestSceneItem]
        var sectionCount: Int {
            return 2
        }
        
        init() {
            sent = []
            pending = []
        }
        
        func itemCount(in section: Int) -> Int {
            return value(in: section,
                pendingValue: { return pending.count },
                sentValue:    { return sent.count },
                defaultValue: { return 0 })
        }
        
        func appendSentRequests(_ requests: [Contact.Request]) {
            sent.append(contentsOf: requests.map({ ContactRequestSceneItem(request: $0) }))
        }
        
        func appendPendingRequests(_ requests: [Contact.Request]) {
            pending.append(contentsOf: requests.map({ ContactRequestSceneItem(request: $0) }))
        }
        
        func item(in section: Int, at row: Int) -> ContactRequestSceneItem? {
            return value(in: section,
                pendingValue: {
                    guard row >= 0, row < pending.count else { return nil }
                    return pending[row]
                },
                sentValue: {
                    guard row >= 0, row < sent.count else { return nil }
                    return sent[row]
                },
                defaultValue: {
                    return nil
                })
        }
        
        func headerTitle(in section: Int) -> String? {
            return value(in: section,
                pendingValue: { return pending.isEmpty ? nil : "PENDING" },
                sentValue:    { return sent.isEmpty ? nil : "SENT" },
                defaultValue: { return nil })
        }
        
        func updateMessageShown(in section: Int, at row: Int, isShown: Bool) {
            switch section {
            case 0:
                guard row >= 0, row < pending.count else { return }
                pending[row].isMessageShown = isShown
            
            case 1:
                guard row >= 0, row < sent.count else { return }
                sent[row].isMessageShown = isShown
            
            default:
                break
            }
        }
        
        func updateAcceptStatus(for id: String, status: ContactRequestSceneItem.ActionStatus) {
            updateStatus(for: id, status: status, actionName: .accept)
        }
        
        func updateIgnoreStatus(for id: String, status: ContactRequestSceneItem.ActionStatus) {
            updateStatus(for: id, status: status, actionName: .ignore)
        }
        
        func updateRevokeStatus(for id: String, status: ContactRequestSceneItem.ActionStatus) {
            updateStatus(for: id, status: status, actionName: .revoke)
        }
        
        func updateStatus(for id: String, status: ContactRequestSceneItem.ActionStatus, actionName: ContactRequestSceneItem.ActionName) {
            var index = pending.index(where: { $0.request.id == id })
            
            if index != nil {
                switch actionName {
                case .accept: pending[index!].action.accept = status
                case .ignore: pending[index!].action.ignore = status
                case .revoke: pending[index!].action.revoke = status
                }
                return
            }
            
            index = sent.index(where: { $0.request.id == id })
            
            if index != nil {
                switch actionName {
                case .revoke: sent[index!].action.revoke = status
                case .ignore: sent[index!].action.ignore = status
                default: break
                }
            }
        }
        
        func updateForRemovedRequest(withID id: String) {
            // TODO:
//            switch sectionCategory(withRequestID: id) {
//            case .pending: updateRevokeStatus(for: id, status: .ok)
//            case .sent: updateIgnoreStatus(for: id, status: .ok)
//            case .none: break
//            }
        }
        
        func sectionCategory(for section: Int) -> ContactRequestSceneItem.SectionCategory {
             return value(in: section,
                pendingValue: { return .pending },
                sentValue:    { return .sent },
                defaultValue: { return .none })
        }
        
        private func sectionCategory(withRequestID id: String) -> ContactRequestSceneItem.SectionCategory {
            var index = pending.index(where: { $0.request.id == id })
            if index != nil  {
                return .pending
            }
            
            index = sent.index(where: { $0.request.id == id })
            if index != nil {
                return .sent
            }
            
            return .none
        }
        
        private func value<T>(in section: Int, pendingValue: () -> T, sentValue: () -> T, defaultValue: () -> T) -> T {
            switch section {
            case 0:  return pendingValue()
            case 1:  return sentValue()
            default: return defaultValue()
            }
        }
    }
}
