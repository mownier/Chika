//
//  ContactRequestScene.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

@objc protocol ContactRequestSceneInteraction: class {
    
    func didTapBack()
}

class ContactRequestScene: UIViewController {

    var tableView: UITableView!
    
    var theme: ContactRequestSceneTheme
    var data: ContactRequestSceneData
    var worker: ContactRequestSceneWorker
    var flow: ContactRequestSceneFlow
    var setup: ContactRequestSceneSetup
    var cellFactory: ContactRequestSceneCellFactory
    var waypoint: TNCore.ExitWaypoint
    
    init(theme: ContactRequestSceneTheme,
        data: ContactRequestSceneData,
        worker: ContactRequestSceneWorker,
        flow: ContactRequestSceneFlow,
        setup: ContactRequestSceneSetup,
        cellFactory: ContactRequestSceneCellFactory,
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
    
    convenience init() {
        let theme = Theme()
        let data = Data()
        let worker = Worker()
        let flow = Flow()
        let cellFactory = ContactRequestSceneCell.Factory()
        let setup = Setup()
        let waypoint = PushWaypointSource()
        self.init(theme: theme, data: data, worker: worker, flow: flow, setup: setup, cellFactory: cellFactory, waypoint: waypoint)
        worker.output = self
        flow.scene = self
        //waypoint.scene = self
        setup.theme = theme
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
        tableView = UITableView()
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = 0
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "button_back"), style: .plain, target: self, action: #selector(self.didTapBack))
        navigationItem.leftBarButtonItem = back
        
        let _ = setup.formatTitle(in: navigationItem)
        
        worker.listenOnAddedContactRequests()
    }
    
    override func viewDidLayoutSubviews() {
        cellFactory.prototype?.bounds.size.width = view.bounds.width
        
        var rect = CGRect.zero
        
        rect.size = view.bounds.size
        tableView.frame = rect
    }
    
    func ignore(for item: ContactRequestSceneItem, at indexPath: IndexPath) {
        let _ = data.updateIgnoreStatus(for: item.request.id, status: .requesting)
        tableView.reloadRows(at: [indexPath], with: .fade)
        worker.ignorePendingRequest(withID: item.request.id)
    }
    
    func accept(for item: ContactRequestSceneItem, at indexPath: IndexPath) {
        let _ = data.updateAcceptStatus(for: item.request.id, status: .requesting)
        tableView.reloadRows(at: [indexPath], with: .fade)
        worker.acceptPendingRequest(withID: item.request.id)
    }
    
    func showMessage(for item: ContactRequestSceneItem, at indexPath: IndexPath) {
        data.updateMessageShown(at: indexPath.row, isShown: !item.isMessageShown)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

extension ContactRequestScene: ContactRequestSceneInteraction {
    
    func didTapBack() {
        worker.unlistenOnAddedContactRequests()
        let _ = waypoint.exit()
    }
}

extension ContactRequestScene: ContactRequestSceneWorkerOutput {
    
    func workerDidReceiveContactRequest(_ request: Contact.Request) {
        data.appendRequests([request])
        tableView.reloadData()
    }
    
    func workerDidAcceptPendingRequest(withID id: String) {
        guard let row = data.updateAcceptStatus(for: id, status: .ok) else { return }
        let indexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func workerDidIgnorePendingRequest(withID id: String) {
        guard let row = data.updateIgnoreStatus(for: id, status: .ok) else { return }
        let indexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func workerDidAcceptPendingRequest(withError error: Swift.Error, id: String) {
        guard let row = data.updateAcceptStatus(for: id, status: .retry) else { return }
        let indexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func workerDidIgnorePendingRequest(withError error: Swift.Error, id: String) {
        guard let row = data.updateIgnoreStatus(for: id, status: .retry) else { return }
        let indexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

extension ContactRequestScene: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data.headerTitle
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return setup.headerHeight(withTitle: data.headerTitle)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = data.item(at: indexPath.row)
        return setup.height(for: cellFactory.prototype, theme: theme, item: item, action: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = data.item(at: indexPath.row)
        return setup.swipeActionsConfig(
            for: item,
            ignore: { [weak self] in
                guard let this = self, let item = item else { return }
                this.ignore(for: item, at: indexPath)
            },
            accept: { [weak self] in
                guard let this = self, let item = item else { return }
                this.accept(for: item, at: indexPath)
            },
            showMessage: { [weak self] in
                guard let this = self, let item = item else { return }
                this.showMessage(for: item, at: indexPath)
            })
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.textColor = theme.headerTextColor
        header.textLabel?.font = theme.headerFont
        header.backgroundView?.backgroundColor = theme.headerBGColor
    }
}

extension ContactRequestScene: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellFactory.build(using: tableView, reuseID: "Cell", theme: theme)
        let item = data.item(at: indexPath.row)
        let _ = setup.format(cell: cell, theme: theme, item: item, action: self)
        return cell
    }
}

extension ContactRequestScene: ContactRequestSceneCellAction {
    
}
