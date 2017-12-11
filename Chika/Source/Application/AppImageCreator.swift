//
//  AppImageCreator.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/11/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol AppImageCreator: class {

    func create(for view: UIView) -> UIImage?
}

class ImageCreator: AppImageCreator {
    
    func create(for view: UIView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        
        return image
    }
}
