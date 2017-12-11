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
        
        case accept, ignore, revoke
    }
    
    enum SectionCategory {
        
        case none, pending, sent
    }
    
    struct Action {
        
        var accept: ActionStatus
        var ignore: ActionStatus
        var revoke: ActionStatus
        
        init() {
            self.accept = .none
            self.ignore = .none
            self.revoke = .none
        }
    }
    
    
    var request: Contact.Request
    var isMessageShown: Bool
    var action: Action
    var requestMessage: String {
        return isMessageShown ? request.message : ""
    }
    var statusText: String {
        switch action.revoke {
        case .ok: return "revoked"
        case .requesting: return "revoking"
        case .retry: return "retry"
        default:
            switch action.accept {
            case .ok: return "accept"
            case .requesting: return "accepting"
            case .retry: return "retry"
            default:
                switch action.ignore {
                case .ok: return "ignore"
                case .requesting: return "ignoring"
                case .retry: return "retry"
                default:
                    return ""
                }
            }
        }
    }
    
    init(request: Contact.Request) {
        self.request = request
        self.isMessageShown = false
        self.action = Action()
    }
}
