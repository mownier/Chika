//
//  SignOutSceneWaypoint.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

protocol SignOutSceneEntryWaypoint: class {
    
    func withDelegate(_ aDelegate: SignOutSceneDelegate?) -> TNCore.EntryWaypoint
}

extension SignOutScene {

    class EntryWaypoint: TNCore.EntryWaypoint, SignOutSceneEntryWaypoint {
        
        var factory: SignOutSceneFactory
        weak var delegate: SignOutSceneDelegate?
        
        init(factory: SignOutSceneFactory = Factory()) {
            self.factory = factory
        }
        
        func enter(from parent: UIViewController) -> Bool {
            let scene = factory.build(withDelegate: delegate)
            DispatchQueue.main.async { [weak self] in
                parent.present(scene, animated: true, completion: nil)
                guard let this = self else { return }
                this.delegate = nil
            }
            return true
        }
        
        func withDelegate(_ aDelegate: SignOutSceneDelegate?) -> TNCore.EntryWaypoint {
            delegate = aDelegate
            return self
        }
    }
}
