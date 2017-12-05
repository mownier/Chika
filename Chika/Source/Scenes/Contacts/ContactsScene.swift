//
//  ContactsScene.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/4/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class ContactsScene: UIViewController {

    var searchView: ContactsSceneSearchView!
    var tableView: UITableView!
    
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
        
        searchView = ContactsSceneSearchView()
        searchView.backgroundColor = theme.searchBGColor
        
        view.addSubview(tableView)
        view.addSubview(searchView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        worker.fetchContacts()
    }
    
    override func viewDidLayoutSubviews() {
        cellFactory.prototype?.bounds.size.width = view.bounds.width
        
        let topInset: CGFloat = view.statusBarFrame().height
        
        var rect = CGRect.zero
        
        rect.size.height = 59 + topInset
        rect.size.width = view.bounds.width
        searchView.frame = rect
    
        rect.origin.y = rect.maxY
        rect.size.height = view.bounds.height - rect.origin.y
        tableView.frame = rect
    }
}

extension ContactsScene: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellFactory.build(using: tableView, reuseID: "ContactsSceneCell", theme: theme)
        let item = data.item(at: indexPath.row)
        let _ = setup.format(cell: cell, theme: theme, item: item)
        return cell
    }
}

extension ContactsScene: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = data.item(at: indexPath.row)
        return setup.height(for: cellFactory.prototype, theme: theme, item: item)
    }
}

extension ContactsScene: ContactsSceneWorkerOutput {
    
    func workerDidFetch(contacts: [Person]) {
        data.removeAll()
        data.append(list: contacts)
        tableView.reloadData()
        
        for person in contacts {
            worker.listenOnActiveStatus(for: person.id)
        }
        
        worker.listenOnAddedContact()
        worker.listenOnRemovedContact()
    }
    
    func workerDidFetchWithError(_ error: Error) {
        tableView.reloadData()
    }
    
    func workerDidChangeActiveStatus(for personID: String, isActive: Bool) {
        guard let row = data.updateActiveStatus(for: personID, isActive: isActive) else {
            return
        }
        
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func workerDidAddContact(_ contact: Person) {
        data.append(list: [contact])
        tableView.reloadData()
        worker.listenOnActiveStatus(for: contact.id)
    }
    
    func workerDidRemoveContact(_ personID: String) {
        data.remove(personID)
        tableView.reloadData()
        worker.unlistenOnActiveStatus(for: personID)
    }
}
