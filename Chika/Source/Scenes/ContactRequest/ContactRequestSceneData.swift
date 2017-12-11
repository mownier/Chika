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
}

extension ContactRequestScene {
    
    class Data: ContactRequestSceneData {
        
        var sent: [ContactRequestSceneItem]
        var pending: [ContactRequestSceneItem]
        var sectionCount: Int {
            if !sent.isEmpty && !pending.isEmpty {
                return 2
            
            } else if !sent.isEmpty || !pending.isEmpty {
                return 1
            
            } else {
                return 0
            }
        }
        
        init() {
            sent = []
            pending = []
        }
        
        func itemCount(in section: Int) -> Int {
            return value(in: section,
                pendingValue: { return pending.count },
                sentValue: { return sent.count },
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
                    
                }, sentValue: {
                    guard row >= 0, row < sent.count else { return nil }
                    return sent[row]
                    
                }, defaultValue: {
                    return nil
                })
        }
        
        func headerTitle(in section: Int) -> String? {
            return value(in: section,
                pendingValue: { return "PENDING" },
                sentValue: { return "SENT" },
                defaultValue: { return nil })
        }
        
        private func value<T>(in section: Int, pendingValue: () -> T, sentValue: () -> T, defaultValue: () -> T) -> T {
            if !pending.isEmpty && !sent.isEmpty {
                switch section {
                case 0: return pendingValue()
                case 1: return sentValue()
                default: return defaultValue()
                }
            }
            
            if !pending.isEmpty {
                return pendingValue()
            }
            
            if !sent.isEmpty {
                return sentValue()
            }
            
            return defaultValue()
        }
    }
}
