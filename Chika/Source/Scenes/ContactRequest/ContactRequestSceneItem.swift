//
//  ContactRequestSceneItem.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

struct ContactRequestSceneItem {

    enum ActionStatus {
        
        case none
        case requesting
        case ok
        case retry
    }
    
    enum ActionName {
        
        case accept, ignore
    }
    
    struct Action {
        
        var accept: ActionStatus
        var ignore: ActionStatus
        
        init() {
            self.accept = .none
            self.ignore = .none
        }
    }
    
    
    var request: Contact.Request
    var isMessageShown: Bool
    var action: Action
    var requestMessage: String {
        return isMessageShown ? request.message : ""
    }
    var statusText: String {
        switch action.accept {
        case .ok: return "accepted"
        case .requesting: return "accepting"
        case .retry: return "retry"
        default:
            switch action.ignore {
            case .ok: return "ignored"
            case .requesting: return "ignoring"
            case .retry: return "retry"
            default:
                return ""
            }
        }
    }
    
    init(request: Contact.Request) {
        self.request = request
        self.isMessageShown = false
        self.action = Action()
    }
}
