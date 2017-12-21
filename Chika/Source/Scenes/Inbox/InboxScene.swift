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
    
    var currentItem: InboxSceneItem?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard currentItem != nil else {
            return
        }
        
        currentItem!.unreadMessageCount = 0
        data.updateMessageCount(for: currentItem!)
        tableView.reloadData()
        currentItem = nil
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
        guard var item = data.item(at: indexPath.row), flow.goToConvo(chat: item.chat, delegate: self) else {
            return
        }
        
        item.unreadMessageCount = 0
        data.updateMessageCount(for: item)
        tableView.reloadRows(at: [indexPath], with: .none)
        currentItem = item
        updateBadge()
    }
    
    func updateBadge() {
        let count = data.unreadChatCount
        tabBarItem.badgeColor = theme.badgeBGColor
        tabBarItem.badgeValue = count == 0 ? nil : "\(count)"
    }
}

extension InboxScene: InboxSceneWorkerOutput {
    
    func workerDidFetch(chats: [Chat]) {
        data.removeAll()
        data.append(list: chats)
        tableView.reloadData()
        
        worker.listenOnRecentChat()
        
        for chat in chats {
            worker.listenOnTypingStatus(for: chat)
            worker.listenOnActiveStatus(for: chat)
            worker.listenOnTitleUpdate(for: chat)
        }
    }
    
    func workerDidFetchWithError(_ error: Error) {
        worker.listenOnRecentChat()
        tableView.reloadData()
    }
    
    func workerDidReceiveRecentChat(_ chat: Chat) {
        let updateResult = data.update(chat)
        if !updateResult.isYours {
            updateBadge()
        }
        tableView.reloadData()
        
        worker.listenOnActiveStatus(for: chat)
        worker.listenOnTypingStatus(for: chat)
        worker.listenOnTitleUpdate(for: chat)
    }
    
    func workerDidChangeActiveStatus(for participantID: String, isActive: Bool) {
        let _ = data.updateActiveStatus(for: participantID, isActive: isActive)
        tableView.reloadData()
    }
    
    func workerDidChangeTypingStatus(for chatID: String, participantID: String, isTyping: Bool) {
        let _ = data.updateTypingStatus(for: chatID, participantID: participantID, isTyping: isTyping)
        tableView.reloadData()
    }
    
    func workerDidUpdateTitle(for chatID: String, title: String) {
        let _ = data.updateTitle(for: chatID, title: title)
        tableView.reloadData()
    }
}

extension InboxScene: ConvoSceneDelegate {
    
    func convoSceneDidUpdateChatModel(_ chat: Chat) {
        currentItem = data.item(for: chat)
    }
}
