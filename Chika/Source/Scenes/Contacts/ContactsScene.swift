//
//  ContactsScene.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/4/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol ContactsSceneInteraction {
    
}

class ContactsScene: UIViewController {

    var tableView: UITableView!
    var indexView: ContactsSceneIndexView!
    
    var theme: ContactsSceneTheme
    var data: ContactsSceneData
    var worker: ContactsSceneWorker
    var cellFactory: ContactsSceneCellFactory
    var flow: ContactsSceneFlow
    var setup: ContactsSceneSetup
    
    init(theme: ContactsSceneTheme, data: ContactsSceneData, worker: ContactsSceneWorker, flow: ContactsSceneFlow, cellFactory: ContactsSceneCellFactory, setup: ContactsSceneSetup) {
        self.theme = theme
        self.data = data
        self.worker = worker
        self.flow = flow
        self.cellFactory = cellFactory
        self.setup = setup
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let theme = Theme()
        let data = Data()
        let worker = Worker()
        let flow = Flow()
        let cellFactory = ContactsSceneCell.Factory()
        let setup = Setup()
        self.init(theme: theme, data: data, worker: worker, flow: flow, cellFactory: cellFactory, setup: setup)
        worker.output = self
        flow.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
        tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = theme.bgColor
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        
        indexView = ContactsSceneIndexView()
        indexView.indexFont = theme.indexFont
        indexView.indexTextColor = theme.indexTextColor
        indexView.indexBGColor = theme.indexBGColor
        indexView.delegate = self
        indexView.isHidden = true
        
        view.addSubview(tableView)
        view.addSubview(indexView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        worker.fetchContacts()
    }
    
    override func viewDidLayoutSubviews() {
        cellFactory.prototype?.bounds.size.width = view.bounds.width
        
        var rect = CGRect.zero

        rect.origin.y = 0
        rect.size.height = view.bounds.height
        rect.size.width = indexView.isHidden ? 0 : 28
        rect.origin.x = view.bounds.width - rect.width - (indexView.isHidden ? 0 : 8)
        indexView.frame = rect
        
        rect.origin.x = 0
        rect.size.width = view.bounds.width - indexView.frame.width - (indexView.isHidden ? 0 : 8)
        tableView.frame = rect
    }
    
    func updateIndexView() {
        indexView.isHidden = tableView.frame.height >= tableView.contentSize.height
        indexView.indexChars = indexView.isHidden ? [] : data.indexChars
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}

extension ContactsScene: ContactsSceneInteraction {
    
}

extension ContactsScene: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellFactory.build(using: tableView, reuseID: "ContactsSceneCell", theme: theme)
        let item = data.item(at: indexPath.row)
        let _ = setup.format(cell: cell, theme: theme, item: item, action: self)
        return cell
    }
}

extension ContactsScene: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = data.item(at: indexPath.row)
        return setup.height(for: cellFactory.prototype, theme: theme, item: item, action: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chat = data.item(at: indexPath.row)?.contact.chat else {
            return
        }
        
        let _ = flow.goToConvo(withChat: chat)
    }
}

extension ContactsScene: ContactsSceneCellAction {
    
}

extension ContactsScene: ContactsSceneWorkerOutput {
    
    func workerDidFetch(contacts: [Contact]) {
        data.removeAll()
        data.appendContacts(contacts)
        tableView.reloadData()

        for contact in contacts {
            worker.listenOnActiveStatus(for: contact.person.id)
        }

        worker.listenOnAddedContact()
        worker.listenOnRemovedContact()

        updateIndexView()
    }
    
    func workerDidFetchWithError(_ error: Swift.Error) {
        tableView.reloadData()
        
        worker.listenOnAddedContact()
        worker.listenOnRemovedContact()
    }
    
    func workerDidChangeActiveStatus(for personID: String, isActive: Bool) {
        guard let row = data.updateActiveStatus(for: personID, isActive: isActive) else {
            return
        }
        
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func workerDidAddContact(_ contact: Contact) {
        data.appendContacts([contact])
        tableView.reloadData()
        worker.listenOnActiveStatus(for: contact.person.id)
        updateIndexView()
    }
    
    func workerDidRemoveContact(_ personID: String) {
        data.remove(personID)
        tableView.reloadData()
        worker.unlistenOnActiveStatus(for: personID)
        updateIndexView()
    }
}

extension ContactsScene: ContactsSceneIndexViewDelegate {
    
    func indexViewDidSelectIndex(_ char: Character) {
        guard let row = data.index(for: char) else {
            return
        }
        
        tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: true)
    }
}
