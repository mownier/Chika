//
//  ContactSelectorScene.swift
//  Chika
//
//  Created Mounir Ybanez on 12/18/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

@objc protocol ContactSelectorSceneInteraction: class {
    
    func didTapBack()
    func didTapDone()
}

protocol ContactSelectorSceneDelegate: class {
    
    func contactSelectorScene(_ scene: ContactSelectorScene, didSelectContacts contacts: [Contact])
}

class ContactSelectorScene: UIViewController {

    var tableView: UITableView!
    var emptyView: ContactSelectorSceneEmptyView!
    
    weak var delegate: ContactSelectorSceneDelegate?
    
    var theme: ContactSelectorSceneTheme
    var data: ContactSelectorSceneData
    var worker: ContactSelectorSceneWorker
    var flow: ContactSelectorSceneFlow
    var setup: ContactSelectorSceneSetup
    var cellFactory: ContactSelectorSceneCellFactory
    var waypoint: TNCore.ExitWaypoint
    
    init(theme: ContactSelectorSceneTheme,
        data: ContactSelectorSceneData,
        worker: ContactSelectorSceneWorker,
        flow: ContactSelectorSceneFlow,
        setup: ContactSelectorSceneSetup,
        cellFactory: ContactSelectorSceneCellFactory,
        waypoint: TNCore.ExitWaypoint) {
        self.theme = theme
        self.data = data
        self.worker = worker
        self.flow = flow
        self.cellFactory = cellFactory
        self.setup = setup
        self.waypoint = waypoint
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(excludedPersons: [Person]) {
        let theme = Theme()
        let data = Data(excludedPersons: excludedPersons.map({ $0.id }))
        let worker = Worker()
        let flow = Flow()
        let cellFactory = ContactSelectorSceneCell.Factory(theme: theme)
        let setup = Setup(theme: theme)
        let waypoint = ContactSelectorScene.ExitWaypoint()
        self.init(theme: theme, data: data, worker: worker, flow: flow, setup: setup, cellFactory: cellFactory, waypoint: waypoint)
        worker.output = self
        flow.scene = self
        waypoint.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(excludedPersons: [])
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
        
        emptyView = ContactSelectorSceneEmptyView()
        emptyView.titleLabel.text = "No contacts to select"
        emptyView.titleLabel.textColor = theme.emptyTitleTextColor
        emptyView.titleLabel.font = theme.emptyTitleFont
        
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = setup.formatTitle(in: navigationItem)
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "button_back"), style: .plain, target: self, action: #selector(self.didTapBack))
        navigationItem.leftBarButtonItem = back
        
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.didTapDone))
        navigationItem.rightBarButtonItem = done
        
        if let font = theme.barItemFont {
            done.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
        }
        
        worker.fetchContacts()
    }
    
    override func viewDidLayoutSubviews() {
        cellFactory.prototype?.bounds.size.width = view.bounds.width
        
        var rect = CGRect.zero
        
        rect = view.bounds
        tableView.frame = rect
        emptyView.frame = tableView.bounds
    }
}

extension ContactSelectorScene: ContactSelectorSceneInteraction {
    
    func didTapBack() {
        let _ = waypoint.exit()
    }
    
    func didTapDone() {
        delegate?.contactSelectorScene(self, didSelectContacts: data.selectedContacts)
        let _ = waypoint.exit()
    }
}

extension ContactSelectorScene: ContactSelectorSceneWorkerOutput {
    
    func workerDidFetch(contacts: [Contact]) {
        data.removeAll()
        data.appendContacts(contacts)
        tableView.backgroundView = data.itemCount == 0 ? emptyView : nil
        tableView.reloadData()
    }
    
    func workerDidFetchWithError(_ error: Swift.Error) {
        tableView.backgroundView = data.itemCount == 0 ? emptyView : nil
        tableView.reloadData()
    }
}

extension ContactSelectorScene: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellFactory.build(using: tableView, reuseID: "ContactSelectorSceneCell")
        let item = data.item(at: indexPath.row)
        let _ = setup.format(cell: cell, item: item, action: self)
        return cell
    }
}

extension ContactSelectorScene: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = data.item(at: indexPath.row)
        return setup.height(for: cellFactory.prototype, item: item)
    }
}

extension ContactSelectorScene: ContactSelectorSceneCellAction {
    
    func contactSelectorSceneCellWillToggleSelection(_ cell: ContactSelectorSceneCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        data.toggleSelectedStatus(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
