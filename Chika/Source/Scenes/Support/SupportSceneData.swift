//
//  SupportSceneData.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import Foundation

protocol SupportSceneData: class {

    var itemCount: Int { get }
    
    func item(at row: Int) -> SupportSceneItem?
}

extension SupportScene {
    
    class Data: SupportSceneData {
    
        var items: [SupportSceneItem]
        var itemCount: Int {
            return items.count
        }
    
        init() {
            self.items = []
            
            var item = SupportSceneItem()
            
            item.label = "FAQ"
            item.url = URL(string: "https://github.com/mownier/Chika")!
            self.items.append(item)
            
            item.label = "Send Feedback"
            self.items.append(item)
            
            item.label = "Report a Problem"
            self.items.append(item)
            
            item.label = "Rate Us"
            self.items.append(item)
            
            item.label = "Terms & Condition"
            self.items.append(item)
            
            item.label = "Privacy Policy"
            self.items.append(item)
        }
    
        func item(at row: Int) -> SupportSceneItem? {
            guard row >= 0, row < items.count else { return nil }
            return items[row]
        }
    }
}
