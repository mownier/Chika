//
//  ContactSceneController.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/13/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class ContactSceneController: UIViewController {

    weak var contactsView: UIView!
    weak var peopleSearchView: UIView!
    
    var factory: SubsceneFactory
    
    init(factory: SubsceneFactory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let contacts = ContactsScene.Factory()
        let peopleSearch = PeopleSearchScene.Factory()
        let factory = SubsceneFactory(contacts: contacts, peopleSearch: peopleSearch)
        self.init(factory: factory)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func loadView() {
        super.loadView()
        
        let peopleSearch = factory.peopleSearch.build(withDelegate: self)
        let contacts = factory.contacts.build()
        addChildViewController(peopleSearch)
        addChildViewController(contacts)
        peopleSearch.didMove(toParentViewController: self)
        contacts.didMove(toParentViewController: self)
        
        contactsView = contacts.view
        peopleSearchView = peopleSearch.view
        
        view.addSubview(peopleSearchView)
        view.addSubview(contactsView)
    }
    
    override func viewDidLayoutSubviews() {
        var rect = CGRect.zero
        
        rect = view.bounds
        peopleSearchView.frame = rect
    
        rect.origin.y = 59 + view.statusBarFrame().height
        rect.size.height = view.bounds.height - rect.minY
        contactsView.frame = rect
    }
}

extension ContactSceneController: PeopleSearchSceneDelegate {
    
    func peopleSearchSceneDidBeginSearching() {
        view.sendSubview(toBack: contactsView)
    }
    
    func peopleSearchSceneDidEndSearching() {
        view.bringSubview(toFront: contactsView)
    }
}


