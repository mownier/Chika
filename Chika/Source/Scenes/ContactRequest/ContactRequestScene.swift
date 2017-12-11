//
//  ContactRequestScene.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

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
    var waypoint: AppExitWaypoint
    
    var ignoreImage: UIImage?
    var acceptImage: UIImage?
    var showMessageImage: UIImage?
    var hideMessageImage: UIImage?
    var revokeImage: UIImage?
    var retryImage: UIImage?
    var ignoringImage: UIImage?
    var acceptingImage: UIImage?
    var revokingImage: UIImage?
    var revokedImage: UIImage?
    var acceptedImage: UIImage?
    var ignoredImage: UIImage?
    
    init(theme: ContactRequestSceneTheme,
        data: ContactRequestSceneData,
        worker: ContactRequestSceneWorker,
        flow: ContactRequestSceneFlow,
        setup: ContactRequestSceneSetup,
        cellFactory: ContactRequestSceneCellFactory,
        waypoint: AppExitWaypoint) {
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
        let waypoint = ContactRequestScene.ExitWaypoint()
        self.init(theme: theme, data: data, worker: worker, flow: flow, setup: setup, cellFactory: cellFactory, waypoint: waypoint)
        worker.output = self
        flow.scene = self
        waypoint.scene = self
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
        
        worker.fetchSentRequests()
        worker.listenOnContactRequests()
    }
    
    override func viewDidLayoutSubviews() {
        cellFactory.prototype?.bounds.size.width = view.bounds.width
        
        var rect = CGRect.zero
        
        rect.size = view.bounds.size
        tableView.frame = rect
    }
    
    func revoke(for item: ContactRequestSceneItem, at indexPath: IndexPath) {
        data.updateRevokeStatus(for: item.request.id, status: .requesting)
        tableView.reloadRows(at: [indexPath], with: .fade)
        worker.revokeSentRequest(withID: item.request.id)
    }
    
    func ignore(for item: ContactRequestSceneItem, at indexPath: IndexPath) {
        data.updateIgnoreStatus(for: item.request.id, status: .requesting)
        tableView.reloadRows(at: [indexPath], with: .fade)
        worker.ignorePendingRequest(withID: item.request.id)
    }
    
    func accept(for item: ContactRequestSceneItem, at indexPath: IndexPath) {
        data.updateAcceptStatus(for: item.request.id, status: .requesting)
        tableView.reloadRows(at: [indexPath], with: .fade)
        worker.acceptPendingRequest(withID: item.request.id)
    }
    
    func showMessage(for item: ContactRequestSceneItem, at indexPath: IndexPath) {
        data.updateMessageShown(in: indexPath.section, at: indexPath.row, isShown: !item.isMessageShown)
        tableView.reloadRows(at: [indexPath], with: .fade)
        worker.acceptPendingRequest(withID: item.request.id)
    }
}

extension ContactRequestScene: ContactRequestSceneInteraction {
    
    func didTapBack() {
        let _ = waypoint.exit()
    }
}

extension ContactRequestScene: ContactRequestSceneWorkerOutput {

    func workerDidFetchSentRequests(_ requests: [Contact.Request]) {
        data.appendSentRequests(requests)
        tableView.reloadData()
    }
    
    func workerDidFetchSentRequestsWithError(_ info: Error) {
        tableView.reloadData()
    }
    
    func workerDidReceiveContactRequest(_ request: Contact.Request) {
        data.appendPendingRequests([request])
        tableView.reloadData()
    }
    
    func workerDidRevokeSentRequest(withID id: String) {
        data.updateRevokeStatus(for: id, status: .ok)
    }
    
    func workerDidAcceptPendingRequest(withID id: String) {
        data.updateAcceptStatus(for: id, status: .ok)
    }
    
    func workerDidIgnorePendingRequest(withID id: String) {
        data.updateIgnoreStatus(for: id, status: .ok)
    }
    
    func workerDidRevokeSentRequest(withError error: Error, id: String) {
        data.updateRevokeStatus(for: id, status: .retry)
    }
    
    func workerDidAcceptPendingRequest(withError error: Error, id: String) {
        data.updateAcceptStatus(for: id, status: .retry)
    }
    
    func workerDidIgnorePendingRequest(withError error: Error, id: String) {
        data.updateIgnoreStatus(for: id, status: .retry)
    }
}

extension ContactRequestScene: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data.headerTitle(in: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return setup.headerHeight(withTitle: data.headerTitle(in: section))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = data.item(in: indexPath.section, at: indexPath.row)
        return setup.height(for: cellFactory.prototype, theme: theme, item: item, action: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = data.item(in: indexPath.section, at: indexPath.row)
        let category = data.sectionCategory(for: indexPath.section)
        return setup.swipeActionsConfig(
            for: item,
            category: category,
            revoke: { [weak self] in
                guard let this = self, let item = item else { return }
                this.revoke(for: item, at: indexPath)
            },
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.itemCount(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellFactory.build(using: tableView, reuseID: "Cell", theme: theme)
        let item = data.item(in: indexPath.section, at: indexPath.row)
        let _ = setup.format(cell: cell, theme: theme, item: item, action: self)
        return cell
    }
}

extension ContactRequestScene: ContactRequestSceneCellAction {
    
}
