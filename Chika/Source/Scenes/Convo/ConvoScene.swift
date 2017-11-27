//
//  ConvoScene.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import FirebaseAuth

@objc protocol ConvoSceneInteraction: class {
    
    func didTapBack()
    func didTapSend()
}

class ConvoScene: UIViewController {

    var tableView: UITableView!
    var composerView: ConvoSceneComposerView!
    
    var theme: ConvoSceneTheme
    var worker: ConvoSceneWorker
    var flow: ConvoSceneFlow
    var waypoint: AppExitWaypoint
    var chat: Chat
    var cellManager: ConvoSceneCellManager
    var data: ConvoSceneData
    var setup: ConvoSceneSetup
    
    init(theme: ConvoSceneTheme, worker: ConvoSceneWorker, flow: ConvoSceneFlow, waypoint: AppExitWaypoint, chat: Chat, cellManager: CellManager, data: ConvoSceneData, setup: ConvoSceneSetup) {
        self.theme = theme
        self.worker = worker
        self.flow = flow
        self.waypoint = waypoint
        self.chat = chat
        self.cellManager = cellManager
        self.data = data
        self.setup = setup
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(chat: Chat) {
        let theme = Theme()
        let worker = Worker(chatID: chat.id)
        let flow = Flow()
        let waypoint = ExitWaypoint()
        let cellManager = ConvoScene.CellManager()
        let data = Data()
        let setup = Setup()
        self.init(theme: theme, worker: worker, flow: flow, waypoint: waypoint, chat: chat, cellManager: cellManager, data: data, setup: setup)
        waypoint.scene = self
        worker.output = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        var chat = Chat()
        chat.title = "Chat"
        self.init(chat: chat)
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
        tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = theme.bgColor
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
        cellManager.assignTableView(tableView)
        cellManager.registerLeftCell()
        cellManager.registerRightCell()
        
        composerView = ConvoSceneComposerView()
        composerView.backgroundColor = theme.composerViewBGColor
        composerView.strip.backgroundColor = theme.composerViewStripColor
        composerView.contentInput.tintColor = theme.composerViewTintColor
        composerView.contentInput.textColor = theme.composerViewContentTextColor
        composerView.contentInput.font = theme.composerViewContentFont
        composerView.placeholderLabel.font = theme.composerViewContentFont
        composerView.placeholderLabel.textColor = theme.composerViewContentTextColor
        composerView.sendButton.addTarget(self, action: #selector(self.didTapSend), for: .touchUpInside)
        composerView.sendButton.tintColor = theme.composerViewTintColor
        composerView.sendButton.setTitleColor(theme.composerViewContentTextColor, for: .normal)
        composerView.sendButton.titleLabel?.font = theme.composerViewSendFont
        
        view.addSubview(tableView)
        view.addSubview(composerView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "button_back"), style: .plain, target: self, action: #selector(self.didTapBack))
        navigationItem.leftBarButtonItem = back
        navigationItem.title = chat.title
        
        let _ = worker.fetchNewMessages()
    }
    
    override func viewDidLayoutSubviews() {
        var rect = CGRect.zero
        
        rect.size.width = view.bounds.width
        rect.size.height = 59 + view.safeAreaInsets.bottom
        rect.origin.y = view.bounds.height - rect.height
        composerView.frame = rect
        
        rect.origin.y = 0
        rect.size.height = view.bounds.height - rect.height
        tableView.frame = rect
        
        cellManager.leftPrototype?.bounds.size.width = tableView.frame.width
        cellManager.rightPrototype?.bounds.size.width = tableView.frame.width
    }
}

extension ConvoScene: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.messageCount(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = data.message(at: indexPath)
        var nextIndexPath = indexPath
        nextIndexPath.row -= 1
        let prevMessage = data.message(at: nextIndexPath)
        let cell = setup.formatCell(using: cellManager, theme: theme, message: message, prevMessage: prevMessage)
        return cell
    }
}

extension ConvoScene: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = data.message(at: indexPath)
        var nextIndexPath = indexPath
        nextIndexPath.row -= 1
        let prevMessage = data.message(at: nextIndexPath)
        return setup.cellHeight(using: cellManager, theme: theme, message: message, prevMessage: prevMessage)
    }
}

extension ConvoScene: ConvoSceneWorkerOutput {
    
    func workerDidFetchNew(messages: [Message]) {
        data.removeAll()
        data.append(list: messages)
        tableView.reloadData()
    }
    
    func workerDidFetchNext(messages: [Message]) {
        data.append(list: messages)
        tableView.reloadData()
    }
    
    func workerDidFetchWithError(_ error: Error) {
        tableView.reloadData()
    }
    
    func workerDidSend(message: Message) {
        data.append(list: [message])
        tableView.reloadData()
    }
    
    func workerDidSendWithError(_ error: Error) {
        
    }
}

extension ConvoScene: ConvoSceneInteraction {
    
    func didTapBack() {
        let _ = waypoint.exit()
    }
    
    func didTapSend() {
        let _ = worker.sendMessage(composerView.contentInput.text)
        composerView.updateContent("")
        composerView.contentInput.resignFirstResponder()
    }
}
