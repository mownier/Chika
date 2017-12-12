//
//  ContactRequestSceneData.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol ContactRequestSceneData: class {

    var itemCount: Int { get }
    var headerTitle: String? { get }
    
    func item(at row: Int) -> ContactRequestSceneItem?
    func appendRequests(_ requests: [Contact.Request])
    func updateMessageShown(at row: Int, isShown: Bool)
    func updateAcceptStatus(for id: String, status: ContactRequestSceneItem.ActionStatus) -> Int?
    func updateIgnoreStatus(for id: String, status: ContactRequestSceneItem.ActionStatus) -> Int?
}

extension ContactRequestScene {
    
    class Data: ContactRequestSceneData {
        
        var items: [ContactRequestSceneItem]
        var itemCount: Int { return items.count }
        var headerTitle: String? { return items.isEmpty ? nil : "PENDING" }
        
        init() {
            items = []
        }
        
        func appendRequests(_ requests: [Contact.Request]) {
            items.append(contentsOf: requests.map({ ContactRequestSceneItem(request: $0) }))
        }
        
        func item(at row: Int) -> ContactRequestSceneItem? {
            guard row >= 0, row < items.count else { return nil }
            return items[row]
        }
        
        func updateMessageShown(at row: Int, isShown: Bool) {
            guard row >= 0, row < items.count else { return }
            items[row].isMessageShown = isShown
        }
        
        func updateAcceptStatus(for id: String, status: ContactRequestSceneItem.ActionStatus) -> Int? {
            return updateStatus(for: id, status: status, actionName: .accept)
        }
        
        func updateIgnoreStatus(for id: String, status: ContactRequestSceneItem.ActionStatus) -> Int? {
            return updateStatus(for: id, status: status, actionName: .ignore)
        }
        
        private func updateStatus(for id: String, status: ContactRequestSceneItem.ActionStatus, actionName: ContactRequestSceneItem.ActionName) -> Int? {
            guard let index = items.index(where: { $0.request.id == id }) else { return nil }
            switch actionName {
            case .accept: items[index].action.accept = status
            case .ignore: items[index].action.ignore = status
            }
            return index
        }
    }
}
