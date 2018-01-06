//
//  ChatCreatorScene.swift
//  Chika
//
//  Created Mounir Ybanez on 12/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

@objc protocol ChatCreatorSceneInteraction: class {
    
    func didTapBack()
    func didTapDone()
}

protocol ChatCreatorSceneDelegate: class {
    
    func chatCreatorSceneDidCreateChat(_ chat: Chat)
}

class ChatCreatorScene: UIViewController {

    var headerView: ChatCreatorSceneHeaderView!
    var tableView: UITableView!
    
    weak var delegate: ChatCreatorSceneDelegate?
    
    var theme: ChatCreatorSceneTheme
    var data: ChatCreatorSceneData
    var worker: ChatCreatorSceneWorker
    var flow: ChatCreatorSceneFlow
    var setup: ChatCreatorSceneSetup
    var cellFactory: ChatCreatorSceneCellFactory
    var waypoint: TNCore.ExitWaypoint
    
    init(theme: ChatCreatorSceneTheme,
        data: ChatCreatorSceneData,
        worker: ChatCreatorSceneWorker,
        flow: ChatCreatorSceneFlow,
        setup: ChatCreatorSceneSetup,
        cellFactory: ChatCreatorSceneCellFactory,
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
    
    convenience init(participants: [Person], limit: UInt) {
        let theme = Theme()
        let data = Data(participants: participants, limit: limit)
        let worker = Worker()
        let flow = Flow()
        let cellFactory = ChatCreatorSceneCell.Factory(theme: theme)
        let setup = Setup(theme: theme)
        let waypoint = ChatCreatorScene.ExitWaypoint()
        self.init(theme: theme, data: data, worker: worker, flow: flow, setup: setup, cellFactory: cellFactory, waypoint: waypoint)
        worker.output = self
        flow.scene = self
        waypoint.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(participants: [], limit: 2)
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
        tableView = UITableView()
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = 64
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        headerView = ChatCreatorSceneHeaderView()
        headerView.avatar.backgroundColor = theme.avatarBGColor
        headerView.titleInput.textColor = theme.inputTextColor
        headerView.titleInput.tintColor = theme.inputTextColor
        headerView.titleInput.font = theme.inputFont
        headerView.messageInput.textColor = theme.inputTextColor
        headerView.messageInput.tintColor = theme.inputTextColor
        headerView.messageInput.font = theme.inputFont
        
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = setup.formatTitle(in: navigationItem)
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "button_back"), style: .plain, target: self, action: #selector(self.didTapBack))
        navigationItem.leftBarButtonItem = back
        
        changeToDoneBarItem()
        
        worker.fetchContacts()
    }
    
    override func viewDidLayoutSubviews() {
        cellFactory.prototype?.bounds.size.width = view.bounds.width
        
        var rect = CGRect.zero
        
        rect = view.bounds
        tableView.frame = rect
        
        rect.size.height = 94
        headerView.frame = rect
        tableView.tableHeaderView = headerView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    func changeToIndicatorBarItem() {
        let indicator = UIActivityIndicatorView()
        indicator.color = theme.indicatorColor
        indicator.startAnimating()
        let barItem = UIBarButtonItem(customView: indicator)
        navigationItem.rightBarButtonItem = barItem
    }
    
    func changeToDoneBarItem() {
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.didTapDone))
        navigationItem.rightBarButtonItem = done
        
        if let font = theme.barItemFont {
            done.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
        }
    }
}

extension ChatCreatorScene: ChatCreatorSceneInteraction {
    
    func didTapBack() {
        let _ = waypoint.exit()
    }
    
    func didTapDone() {
        view.endEditing(true)
        changeToIndicatorBarItem()
        let title = headerView.titleInput.text ?? ""
        let message = headerView.messageInput.text ?? ""
        worker.createChat(withTitle: title, message: message, participants: data.selectedParticipants)
    }
}

extension ChatCreatorScene: ChatCreatorSceneWorkerOutput {
    
    func workerDidCreateChat(_ chat: Chat) {
        delegate?.chatCreatorSceneDidCreateChat(chat)
        let _ = waypoint.exit()
    }
    
    func workerDidCreateChatWithError(_ error: Swift.Error) {
        changeToDoneBarItem()
    }
    
    func workerDidFetch(contacts: [Contact]) {
        data.removeAll()
        data.appendContacts(contacts)
        tableView.reloadData()
    }
    
    func workerDidFetchWithError(_ error: Swift.Error) {
        tableView.reloadData()
    }
}

extension ChatCreatorScene: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellFactory.build(using: tableView, reuseID: "Cell")
        let item = data.item(at: indexPath.row)
        let _ = setup.format(cell: cell, item: item, action: self)
        return cell
    }
}

extension ChatCreatorScene: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = data.item(at: indexPath.row)
        return setup.height(for: cellFactory.prototype, item: item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension ChatCreatorScene: ChatCreatorSceneCellAction {
    
    func chatCreatorSceneCellWillToggleSelection(_ cell: ChatCreatorSceneCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        data.toggleSelectedStatus(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
