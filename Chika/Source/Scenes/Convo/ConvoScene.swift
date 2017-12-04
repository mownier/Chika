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
    
    var isTypingViewHidden: Bool = true {
        didSet {
            guard oldValue != isTypingViewHidden else {
                if !isTypingViewHidden {
                    tableView.reloadSections([1], with: .none)
                }
                return
            }
            
            isTypingViewHidden ? hideTypingView() : showTypingView()
        }
    }
    
    var typingStatusText: String = "" {
        didSet {
            isTypingViewHidden = typingStatus.isEmpty
        }
    
    }
    
    var typingStatus: [String: Bool] = [:] {
        didSet {
            let typingPersons: [Person] = chat.participants.filter({ typingStatus[$0.id] ?? false })
            
            guard typingPersons.count > 0 else {
                typingStatusText = ""
                return
            }
            
            if typingPersons.count == 1 {
                typingStatusText = "\(typingPersons[0].name) is typing..."
                return
            }
            
            if typingPersons.count == 2 {
                typingStatusText = "\(typingPersons[0].name) and \(typingPersons[1].name) are typing..."
                return
            }
            
            var personText = ""
            for (index, person) in typingPersons.enumerated() {
                if index == typingPersons.count - 1 {
                    personText.append("and \(person.name)")
                    continue
                }
                
                personText.append("\(person.name), ")
            }
            
            typingStatusText = "\(personText) are typing..."
        }
    }
    
    var notifCenter: NotificationCenter = NotificationCenter.default
    
    deinit {
        notifCenter.removeObserver(self)
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
        
        tableView.register(ConvoSceneTypingView.self, forCellReuseIdentifier: "TypingView")
        
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
        composerView.contentInput.delegate = self
        
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
        
        worker.listenOnRecentMessage()
        worker.listenOnTypingStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardObserer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeKeyboardObserver()
    }
    
    override func viewDidLayoutSubviews() {
        var rect = CGRect.zero
        
        rect.size.width = view.bounds.width
        rect.size.height = 59 + view.safeAreaInsets.bottom
        rect.origin.y = composerView.isKeyboardShown ? composerView.frame.origin.y : view.bounds.height - rect.height
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
        
        let indexPath: IndexPath
        
        if isTypingViewHidden {
            indexPath = IndexPath(row: data.messageCount(in: 0) - 1, section: 0)
            
        } else {
            indexPath = IndexPath(row: 0, section: 1)
        }
        
        guard animated else {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let scene = self else {
                return
            }
            
            scene.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    func showTypingView() {
        tableView.reloadData()
        if isAtBottom {
            scrollToBottom()
        }
    }
    
    func hideTypingView() {
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: UIViewAnimationOptions.curveEaseOut,
            animations: { [weak self] in
                self?.tableView.deleteRows(at: [IndexPath(row: 0, section: 1)], with: .bottom)
        }) { _ in }
    }
    
    @objc func keyboardWillShow(_ notif: Notification) {
        guard !composerView.isKeyboardShown else {
            return
        }
        
        composerView.isKeyboardShown = true
        
        prevOriginY = composerView.frame.origin.y
        prevBottomOffset = tableView.contentInset.bottom
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] _ in
            guard let this = self else { return }
            let keyboardSize = UIApplication.shared.windows[1].subviews[0].subviews[0].bounds.size
            
            let prevY = this.composerView.frame.origin.y
            let newY = this.view.bounds.height - this.composerView.bounds.height - keyboardSize.height + this.view.safeAreaInsets.bottom
            
            if newY != prevY {
                UIView.animate(
                    withDuration: 0.25,
                    delay: 0,
                    options: UIViewAnimationOptions(rawValue: 7 << 16),
                    animations: {
                        this.composerView.frame.origin.y = newY
                }) { _ in }
            }
            
            let prevBottom = this.tableView.contentInset.bottom
            let newBottom = this.prevBottomOffset + keyboardSize.height - this.view.safeAreaInsets.bottom
            if newBottom != prevBottom {
                UIView.animate(
                    withDuration: 0.25,
                    delay: 0,
                    options: UIViewAnimationOptions(rawValue: 7 << 16),
                    animations: {
                        this.tableView.contentOffset.y += (newBottom - prevBottom)
                        this.tableView.contentInset.bottom = newBottom
                        this.tableView.scrollIndicatorInsets.bottom = newBottom
                }) { _ in }
            }
        })
        timer?.fire()
    }
    
    @objc func keyboardWillHide() {
        composerView.isKeyboardShown = false
        
        timer?.invalidate()
        timer = nil
        
        composerView.frame.origin.y = prevOriginY
        tableView.contentInset.bottom = prevBottomOffset
        tableView.scrollIndicatorInsets.bottom = prevBottomOffset
    }
    
    func addKeyboardObserer() {
        notifCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        notifCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardObserver() {
        notifCenter.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        notifCenter.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    var prevOriginY: CGFloat = 0
    var prevBottomOffset: CGFloat = 0
    var timer: Timer?
}

extension ConvoScene: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return data.messageCount(in: 0)
        
        case 1:
            if isTypingViewHidden {
                return 0
            }
            return 1
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let message = data.message(at: indexPath)
            var nextIndexPath = indexPath
            nextIndexPath.row -= 1
            let prevMessage = data.message(at: nextIndexPath)
            let cell = setup.formatCell(using: cellManager, theme: theme, message: message, prevMessage: prevMessage)
            return cell
        
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypingView") as! ConvoSceneTypingView
            cell.infoLabel.font = theme.typingStatusFont
            cell.infoLabel.textColor = theme.typingStatusTextColor
            cell.infoLabel.text = typingStatusText
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

extension ConvoScene: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let message = data.message(at: indexPath)
            var nextIndexPath = indexPath
            nextIndexPath.row -= 1
            let prevMessage = data.message(at: nextIndexPath)
            return setup.cellHeight(using: cellManager, theme: theme, message: message, prevMessage: prevMessage)
        
        case 1:
            return 44
        
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == loadMoreRowThreshold {
                let _ = worker.fetchNextMessages()
            }
        
        default:
            break
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
    
    func workerDidUpdateTypingStatus(for personID: String, isTyping: Bool) {
        if isTyping {
            typingStatus[personID] = isTyping
            
        } else {
            typingStatus.removeValue(forKey: personID)
        }
    }
}

extension ConvoScene: ConvoSceneInteraction {
    
    func didTapBack() {
        worker.unlisteOnRecentMessage()
        worker.unlistenOnTypingStatus()
        let _ = waypoint.exit()
    }
    
    func didTapSend() {
        worker.changeTypingStatus(false)
        let _ = worker.sendMessage(composerView.contentInput.text)
        composerView.updateContent("")
        composerView.contentInput.resignFirstResponder()
    }
    
    func didTapNewMessageCount() {
        scrollToBottom()
    }
}

extension ConvoScene: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        worker.changeTypingStatus(!textView.text.isEmpty)
    }
}
