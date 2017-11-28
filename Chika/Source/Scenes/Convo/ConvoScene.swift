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
    func didTapNewMessageCount()
}

class ConvoScene: UIViewController {

    var tableView: UITableView!
    var composerView: ConvoSceneComposerView!
    var newMessageCountLabel: UILabel!
    
    var theme: ConvoSceneTheme
    var worker: ConvoSceneWorker
    var flow: ConvoSceneFlow
    var waypoint: AppExitWaypoint
    var chat: Chat
    var cellManager: ConvoSceneCellManager
    var data: ConvoSceneData
    var setup: ConvoSceneSetup
    var loadMoreRowThreshold: Int
    
    var isAtBottom: Bool = false
    var newMessageCount: UInt = 0 {
        didSet {
            guard newMessageCount > 0 else {
                newMessageCountLabel.isHidden = true
                return
            }
            
            var info = "new messages"
            if newMessageCount == 1 {
                info = "new message"
            }
            newMessageCountLabel.text = "\(newMessageCount) \(info)"
            newMessageCountLabel.isHidden = false
        }
    }
    
    init(theme: ConvoSceneTheme, worker: ConvoSceneWorker, flow: ConvoSceneFlow, waypoint: AppExitWaypoint, chat: Chat, cellManager: CellManager, data: ConvoSceneData, setup: ConvoSceneSetup) {
        self.theme = theme
        self.worker = worker
        self.flow = flow
        self.waypoint = waypoint
        self.chat = chat
        self.cellManager = cellManager
        self.data = data
        self.setup = setup
        self.loadMoreRowThreshold = 10
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(chat: Chat) {
        let theme = Theme()
        let worker = Worker(chatID: chat.id, participantIDs: chat.participants.map({ $0.id }))
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
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = 0
        
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
        
        newMessageCountLabel = UILabel()
        newMessageCountLabel.textColor = theme.newMessageCountTextColor
        newMessageCountLabel.font = theme.newMessageCountFont
        newMessageCountLabel.textAlignment = .center
        newMessageCountLabel.isHidden = true
        newMessageCountLabel.backgroundColor = theme.newMessageCountBGColor
        newMessageCountLabel.layer.masksToBounds = true
        newMessageCountLabel.isUserInteractionEnabled = true
        
        view.addSubview(tableView)
        view.addSubview(composerView)
        view.addSubview(newMessageCountLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapNewMessageCount))
        tap.numberOfTapsRequired = 1
        newMessageCountLabel.addGestureRecognizer(tap)
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "button_back"), style: .plain, target: self, action: #selector(self.didTapBack))
        navigationItem.leftBarButtonItem = back
        navigationItem.title = chat.title
        
        let _ = worker.fetchNewMessages()
        worker.listenForUpdates()
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
        
        rect.size.width = 200
        rect.size.height = 44
        rect.origin.y = tableView.bounds.height - rect.height - 24
        rect.origin.x = (tableView.bounds.width - rect.width) / 2
        newMessageCountLabel.frame = rect
        newMessageCountLabel.layer.cornerRadius = rect.height / 2
        
        cellManager.leftPrototype?.bounds.size.width = tableView.frame.width
        cellManager.rightPrototype?.bounds.size.width = tableView.frame.width
    }
    
    func scrollToBottom(_ animated: Bool = true) {
        let section: Int = 0
        
        guard data.messageCount(in: section) > 0 else {
            return
        }
        
        guard animated else {
            let indexPath = IndexPath(row: data.messageCount(in: section) - 1, section: section)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let scene = self else {
                return
            }
            
            let indexPath = IndexPath(row: scene.data.messageCount(in: section) - 1, section: section)
            scene.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == loadMoreRowThreshold {
            let _ = worker.fetchNextMessages()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.bounds.height
        let contentHeight = scrollView.contentSize.height
        let bottomInset = scrollView.contentInset.bottom
        let bottomOffset = contentHeight + bottomInset - height
        isAtBottom = scrollView.contentOffset.y >= bottomOffset
        if isAtBottom {
            newMessageCount = 0
        }
    }
}

extension ConvoScene: ConvoSceneWorkerOutput {
    
    func workerDidFetchNew(messages: [Message]) {
        data.removeAll()
        data.pushFront(list: messages)
        tableView.reloadData()
        scrollToBottom(false)
    }
    
    func workerDidFetchNext(messages: [Message]) {
        data.pushFront(list: messages)
        
        let oldOffset = tableView.contentOffset
        let oldSize = tableView.contentSize
        
        tableView.reloadData()
        tableView.layoutIfNeeded()
        
        let newSize = tableView.contentSize
        let newOffset = CGPoint(x: oldOffset.x, y: newSize.height - oldSize.height + oldOffset.y)
        tableView.setContentOffset(newOffset, animated: false)
    }
    
    func workerDidFetchWithError(_ error: Error) {
        tableView.reloadData()
    }
    
    func workerDidSend(message: Message) {
        data.pushRear(list: [message])
        tableView.reloadData()
        scrollToBottom()
    }
    
    func workerDidSendWithError(_ error: Error) {
        tableView.reloadData()
    }
    
    func workerDidUpdateConvo(message: Message) {
        data.pushRear(list: [message])
        
        if isAtBottom {
            tableView.reloadData()
            scrollToBottom()
        
        } else {
            let row = IndexPath(row: data.messageCount(in: 0) - 1, section: 0)
            tableView.beginUpdates()
            tableView.insertRows(at: [row], with: .none)
            tableView.endUpdates()
            newMessageCount += 1
        }
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
    
    func didTapNewMessageCount() {
        scrollToBottom()
    }
}
