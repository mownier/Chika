//
//  ConvoSceneData.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/24/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ConvoSceneData: class {
    
    func messageCount(in section: Int) -> Int
    func message(at indexPath: IndexPath) -> Message?
    func append(list: [Message])
    func removeAll()
}

extension ConvoScene {
    
    class Data: ConvoSceneData {
        
        var messages: [Message]
        
        init() {
            messages = []
        }
        
        func messageCount(in section: Int) -> Int {
            return messages.count
        }
        
        func message(at indexPath: IndexPath) -> Message? {
            guard !indexPath.isEmpty, indexPath.row >= 0, indexPath.row < messages.count else {
                return nil
            }
            
            return messages[indexPath.row]
        }
        
        func append(list: [Message]) {
            messages.append(contentsOf: list)
        }
        
        func removeAll() {
            messages.removeAll()
        }
    }
}
