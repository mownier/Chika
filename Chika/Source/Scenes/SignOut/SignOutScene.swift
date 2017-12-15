//
//  SignOutScene.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/15/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol SignOutSceneDelegate: class {
    
    func signOutSceneWillSignOut()
}

class SignOutScene: UIAlertController {
    
    weak var delegate: SignOutSceneDelegate?
    var theme: SignOutSceneTheme = Theme()
    
    override func loadView() {
        super.loadView()
        
        view.tintColor = theme.tintColor
    }
    
    func buildActions() {
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.delegate?.signOutSceneWillSignOut()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        addAction(okAction)
        addAction(cancelAction)
    }
}
