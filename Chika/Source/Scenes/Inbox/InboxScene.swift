//
//  InboxScene.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class InboxScene: UITableViewController {

    var theme: InboxSceneTheme
    var data: InboxSceneData
    var setup: InboxSceneSetup
    var cellManager: InboxSceneCellManager
    var worker: InboxSceneWorker
    var flow: InboxSceneFlow
    
    init(theme: InboxSceneTheme, data: InboxSceneData, setup: InboxSceneSetup, cellManager: InboxSceneCellManager, worker: InboxSceneWorker, flow: InboxSceneFlow) {
        self.theme = theme
        self.data = data
        self.setup = setup
        self.cellManager = cellManager
        self.worker = worker
        self.flow = flow
        super.init(style: .plain)
    }
    
    convenience init() {
        let theme = Theme()
        let data = Data()
        let setup = InboxScene.Setup()
        let cellManager = InboxScene.CellManager()
        let worker = InboxScene.Worker()
        let flow = InboxScene.Flow()
        self.init(theme: theme, data: data, setup: setup, cellManager: cellManager, worker: worker, flow: flow)
        worker.output = self
        flow.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        cellManager.register(in: tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        worker.fetchInbox()
    }
    
    override func viewDidLayoutSubviews() {
        cellManager.prototype?.bounds.size.width = tableView.bounds.width
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isLast = indexPath.row == data.itemCount - 1
        return setup.height(for: cellManager.prototype, theme: theme, item: data.item(at: indexPath.row), isLast: isLast)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.itemCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellManager.dequeue()
        let isLast = indexPath.row == data.itemCount - 1
        let ok = setup.format(cell: cell, theme: theme, item: data.item(at: indexPath.row), isLast: isLast)
        
        if ok {
            return cell!
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let _ = flow.goToConvo(chat: data.item(at: indexPath.row)?.chat)
    }
}

extension InboxScene: InboxSceneWorkerOutput {
    
    func workerDidFetch(chats: [Chat]) {
        data.removeAll()
        data.append(list: chats)
        tableView.reloadData()
        
        worker.listenForInboxUpdates()
    }
    
    func workerDidFetchWithError(_ error: Error) {
        tableView.reloadData()
    }
    
    func workerDidUpdateInbox(chat: Chat) {
        data.update(chat)
        tableView.reloadData()
    }
}
