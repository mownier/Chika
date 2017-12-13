//
//  PeopleSearchSceneInput.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/12/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class PeopleSearchSceneInput: UIView {

    var searchButton: UIButton!
    var searchInput: UITextField!
    var strip: UIView!
    var cancelButton: UIButton!
    var indicator: UIActivityIndicatorView!
    
    var isSearching: Bool = false {
        didSet {
            setNeedsLayout()
            let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) { [weak self] in
                self?.layoutIfNeeded()
            }
            animator.startAnimation()
        }
    }
    
    var isRequesting: Bool = false {
        didSet {
            if isRequesting {
                indicator.startAnimating()
                searchButton.alpha = 0
            
            } else {
                indicator.stopAnimating()
                searchButton.alpha = 1
            }
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
        initSetup()
    }
    
    func initSetup() {
        searchInput = UITextField()
        searchInput.placeholder = "Search people"
        searchInput.contentVerticalAlignment = .center
        searchInput.returnKeyType = .search
        searchInput.autocapitalizationType = .none
        searchInput.autocorrectionType = .no
        
        strip = UIView()
        
        searchButton = UIButton()
        searchButton.setImage(#imageLiteral(resourceName: "button_search"), for: .normal)
        
        cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = true
        
        addSubview(searchInput)
        addSubview(strip)
        addSubview(searchButton)
        addSubview(cancelButton)
        addSubview(indicator)
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        rect.origin.y = statusBarFrame().height
        rect.size.height = bounds.height - rect.origin.y
        rect.size.width = 44
        searchButton.frame = rect
        indicator.frame = rect
        
        rect.size.width = 76
        rect.origin.x = isSearching ? bounds.width - rect.width : bounds.width
        cancelButton.frame = rect
        
        rect.origin.x = searchButton.frame.maxX
        rect.size.width = bounds.width - rect.origin.x - (isSearching ? cancelButton.frame.width : 0)
        searchInput.frame = rect
        
        rect.origin.x = 0
        rect.size.width = bounds.width
        rect.size.height = 1
        rect.origin.y = bounds.height - rect.height
        strip.frame = rect
    }
}
