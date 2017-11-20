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
        
        var inboxScene: InboxSceneFactory
        
        var subscenes: [UIViewController] {
            let item1Scene = inboxScene.build()
            let item2Scene = UIViewController()
            let item3Scene = UIViewController()
            
            let item1 = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
            let item2 = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
            let item3 = UITabBarItem(tabBarSystemItem: .more, tag: 2)
            
            item2Scene.view.backgroundColor = .green
            item3Scene.view.backgroundColor = .blue
            
            item1Scene.tabBarItem = item1
            item2Scene.tabBarItem = item2
            item3Scene.tabBarItem = item3
            
            return [item1Scene, item2Scene, item3Scene]
        }
        
        init(inboxScene: InboxSceneFactory = InboxScene.Factory()) {
            self.inboxScene = inboxScene
        }
    }
}
