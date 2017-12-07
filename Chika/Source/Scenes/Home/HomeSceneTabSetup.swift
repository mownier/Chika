//
//  HomeSceneTabSetup.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol HomeSceneTabSetup: class {

    var subscenes: [UIViewController] { get }
}

extension HomeScene {
    
    class TabSetup: HomeSceneTabSetup {
        
        struct Factory {
            
            var inbox: InboxSceneFactory
            var contacts: ContactsSceneFactory
        }
        
        var factory: Factory
        
        var subscenes: [UIViewController] {
            let item1Scene = factory.inbox.build()
            let item2Scene = factory.contacts.build()
            let item3Scene = UIViewController()
            
            let item1 = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
            let item2 = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
            let item3 = UITabBarItem(tabBarSystemItem: .more, tag: 2)
            
            let _ = item1Scene.view
            let view2 = item2Scene.view
            let _ = item3Scene.view
            
            view2?.setNeedsLayout()
            view2?.layoutIfNeeded()
            
            item1Scene.tabBarItem = item1
            item2Scene.tabBarItem = item2
            item3Scene.tabBarItem = item3
            
            return [item1Scene, item2Scene, item3Scene]
        }
        
        init(factory: Factory) {
            self.factory = factory
        }
        
        convenience init() {
            let inbox = InboxScene.Factory()
            let contacts = ContactsScene.Factory()
            let factory = Factory(inbox: inbox, contacts: contacts)
            self.init(factory: factory)
        }
    }
}
