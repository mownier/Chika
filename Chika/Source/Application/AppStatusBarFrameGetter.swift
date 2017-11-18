//
//  AppStatusBarFrameGetter.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol AppStatusBarFrameGetter: class {

    func statusBarFrame(for app: UIApplication) -> CGRect
}

extension UIView: AppStatusBarFrameGetter {
    
    func statusBarFrame(for app: UIApplication = UIApplication.shared) -> CGRect {
        return app.statusBarFrame
    }
}
