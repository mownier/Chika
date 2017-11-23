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
    
    init(theme: InboxSceneTheme, data: InboxSceneData, setup: InboxSceneSetup, cellManager: InboxSceneCellManager, worker: InboxSceneWorker) {
        self.theme = theme
        self.data = data
        self.setup = setup
        self.cellManager = cellManager
        self.worker = worker
        super.init(style: .plain)
    }
    
    convenience init() {
        let theme = Theme()
        let data = Data()
        let setup = InboxScene.Setup()
        let cellManager = InboxScene.CellManager()
        let worker = InboxScene.Worker()
        self.init(theme: theme, data: data, setup: setup, cellManager: cellManager, worker: worker)
        worker.output = self
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
        return setup.height(for: cellManager.prototype, theme: theme, chat: data.chat(at: indexPath))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.chatCount(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellManager.dequeue()
        let ok = setup.format(cell: cell, theme: theme, chat: data.chat(at: indexPath))
        
        if ok {
            return cell!
        }
        
        return UITableViewCell()
    }
}

extension InboxScene: InboxSceneWorkerOutput {
    
    func workerDidFetch(chats: [Chat]) {
        data.removeAll()
        data.append(list: chats)
        tableView.reloadData()
    }
    
    func workerDidFetchWithError(_ error: Error) {
        tableView.reloadData()
    }
}
