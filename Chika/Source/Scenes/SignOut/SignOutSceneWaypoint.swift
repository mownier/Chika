//
//  SignOutSceneWaypoint.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol SignOutSceneEntryWaypoint: class {
    
    func withDelegate(_ aDelegate: SignOutSceneDelegate?) -> AppEntryWaypoint
}

extension SignOutScene {

    class EntryWaypoint: AppEntryWaypoint, SignOutSceneEntryWaypoint {
        
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
        
        func withDelegate(_ aDelegate: SignOutSceneDelegate?) -> AppEntryWaypoint {
            delegate = aDelegate
            return self
        }
    }
}
