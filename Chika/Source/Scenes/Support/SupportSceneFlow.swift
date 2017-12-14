//
//  SupportSceneFlow.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol SupportSceneFlow: class {

    func goToWebBrowser(withURL: URL)
}

extension SupportScene {
    
    class Flow: SupportSceneFlow {
    
        var application: UIApplication
    
        init(application: UIApplication = .shared) {
            self.application = application
        }
        
        func goToWebBrowser(withURL url: URL) {
            DispatchQueue.main.async { [weak self] in
                self?.application.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
