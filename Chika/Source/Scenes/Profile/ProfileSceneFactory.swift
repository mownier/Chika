//
//  ProfileSceneFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/8/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

protocol ProfileSceneFactory: class {

    func withTheme(_ theme: ProfileSceneTheme) -> ProfileSceneFactory & SceneFactory
}

extension ProfileScene {
    
    class Factory: ProfileSceneFactory, SceneFactory {
        
        var flow: ProfileSceneFlow & SceneInjectable
        var data: ProfileSceneData
        var theme: ProfileSceneTheme
        var setup: ProfileSceneSetup
        var worker: ProfileSceneWorker
        var delegate: SignOutSceneDelegate
        var cellFactory: ProfileSceneCellFactory
        
        init() {
            let flow = Flow()
            let data = Data()
            let theme = Theme()
            let setup = Setup()
            let worker = Worker()
            let delegate = Delegate.SignOut(flow: flow)
            let cellFactory = CellFactory()
            
            self.flow = flow
            self.data = data
            self.theme = theme
            self.setup = setup
            self.worker = worker
            self.delegate = delegate
            self.cellFactory = cellFactory
        }
        
        func withTheme(_ aTheme: ProfileSceneTheme) -> ProfileSceneFactory & SceneFactory {
            theme = aTheme
            return self
        }
        
        func build() -> UIViewController {
            let scene = ProfileScene()
            scene.flow = flow
            scene.data = data
            scene.theme = theme
            scene.setup = setup
            scene.worker = worker
            return scene
        }
    }
}
