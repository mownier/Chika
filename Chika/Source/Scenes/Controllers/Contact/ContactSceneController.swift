//
//  ContactSceneController.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/13/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol ContactSceneControllerInteraction: class {
    
    func didTapCancel()
    func didStartSearching(_ notif: Notification)
}

class ContactSceneController: UIViewController {

    weak var contactsView: UIView!
    weak var peopleSearchView: UIView!
    weak var input: PeopleSearchSceneInput!
    
    var factory: SubsceneFactory
    var notifCenter: NotificationCenter = .default
    
    deinit {
        notifCenter.removeObserver(self)
    }
    
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
        
        view.backgroundColor = .red
        
        let peopleSearch = factory.peopleSearch.build() as! PeopleSearchScene
        addChildViewController(peopleSearch)
        peopleSearch.didMove(toParentViewController: self)
        
        let contacts = factory.contacts.build()
        addChildViewController(contacts)
        contacts.didMove(toParentViewController: self)
        
        contactsView = contacts.view
        peopleSearchView = peopleSearch.view
        
        view.addSubview(peopleSearchView)
        view.addSubview(contactsView)
        
        input = peopleSearch.input
        input.cancelButton.addTarget(self, action: #selector(self.didTapCancel), for: .touchUpInside)
        notifCenter.addObserver(self, selector: #selector(self.didStartSearching(_:)), name: .UITextFieldTextDidBeginEditing, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        var rect = CGRect.zero
        
        rect = view.bounds
        peopleSearchView.frame = rect
    
        rect.origin.y = input.frame.height
        rect.size.height = view.bounds.height - rect.minY
        contactsView.frame = rect
    }
}

extension ContactSceneController: ContactSceneControllerInteraction {
    
    func didTapCancel() {
        view.bringSubview(toFront: contactsView)
    }
    
    func didStartSearching(_ notif: Notification) {
        guard notif.object as? UITextField == input.searchInput else { return }
        view.sendSubview(toBack: contactsView)
    }
}


