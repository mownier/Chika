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
    func didTapSetting()
}

class ConvoScene: UIViewController {

    var tableView: UITableView!
    var composerView: ConvoSceneComposerView!
    var newMessageCountLabel: UILabel!
    var titleView: ConvoSceneTitleView!
    
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
                let name = typingPersons[0].displayName
                typingStatusText = "\(name) is typing..."
                return
            }
            
            if typingPersons.count == 2 {
                let name1 = typingPersons[0].displayName
                let name2 = typingPersons[1].displayName
                typingStatusText = "\(name1) and \(name2) are typing..."
                return
            }
            
            var personText = ""
            for (index, person) in typingPersons.enumerated() {
                let name = person.displayName
                
                if index == typingPersons.count - 1 {
                    personText.append("and \(name)")
                    continue
                }
                
                personText.append("\(name), ")
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
        flow.scene = self
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
        tableView.contentInsetAdjustmentBehavior = .never
        
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
        
        titleView = ConvoSceneTitleView()
        titleView.nameLabel.textColor = theme.titleNameTextColor
        titleView.nameLabel.font = theme.titleNameFont
        titleView.activeLabel.textColor = theme.titleActiveTextColor
        titleView.activeLabel.font = theme.titleActiveFont
        
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
        
        let setting = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.didTapSetting))
        navigationItem.rightBarButtonItem = setting
        
        titleView.nameLabel.text = chat.title
        navigationItem.titleView = titleView
        
        let _ = worker.fetchNewMessages()
        
        worker.listenOnRecentMessage()
        worker.listenOnTypingStatus()
        worker.listenOnPresence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardObserer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        composerView.contentInput.resignFirstResponder()
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
        rect.origin.y = composerView.isKeyboardShown ? newMessageCountLabel.frame.origin.y : tableView.bounds.height - rect.height - 24
        rect.origin.x = (tableView.bounds.width - rect.width) / 2
        newMessageCountLabel.frame = rect
        newMessageCountLabel.layer.cornerRadius = rect.height / 2
        
        rect.origin = .zero
        rect.size.height = navigationController?.navigationBar.bounds.height ?? 0
        rect.size.width = view.bounds.width - 44 * 2
        titleView.frame = rect
        
        cellManager.leftPrototype?.bounds.size.width = tableView.frame.width
        cellManager.rightPrototype?.bounds.size.width = tableView.frame.width
    }
    
    func scrollToBottom(_ animated: Bool = true) {
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
        if tableView.numberOfSections > 1 {
            tableView.reloadSections([1], with: .none)
        
        } else {
            tableView.reloadData()
        }
        
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
        prevCountOriginY = newMessageCountLabel.frame.origin.y
        
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
                        this.newMessageCountLabel.frame.origin.y = newY - this.newMessageCountLabel.frame.height - 24
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
                        this.tableView.contentOffset.y += (newBottom - prevBottom - 0.001)
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
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: UIViewAnimationOptions(rawValue: 7 << 16),
            animations: { [weak self] in
                guard let this = self else { return }
                this.newMessageCountLabel.frame.origin.y = this.prevCountOriginY
                this.composerView.frame.origin.y = this.prevOriginY
                this.tableView.contentInset.bottom = this.prevBottomOffset
                this.tableView.scrollIndicatorInsets.bottom = this.prevBottomOffset
        }) { _ in }

    }
    
    func addKeyboardObserer() {
        notifCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        notifCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardObserver() {
        notifCenter.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        notifCenter.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func updateTitleView() {
        guard let presence = presence else {
            return
        }
        
        let date = NSDate(timeIntervalSince1970: presence.activeOn)
        let dateText = date.timeAgoSinceNow() ?? ""
        titleView.activeLabel.text = "active \(dateText)".lowercased()
        titleView.setNeedsLayout()
        titleView.layoutIfNeeded()
    }
    
    var prevOriginY: CGFloat = 0
    var prevBottomOffset: CGFloat = 0
    var prevCountOriginY: CGFloat = 0
    var timer: Timer?
    var titleRefreshTimer: Timer?
    var presence: Presence?
    var lastOffsetY: CGFloat = 0
    var lastOffsetCapture: TimeInterval = 0
    var isScrolling: Bool = false
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
        
        let endTime = Date().timeIntervalSinceReferenceDate
        let startTime = lastOffsetCapture
        let endPoint = scrollView.contentOffset.y
        let startPoint = lastOffsetY
        let distance = Double(fabsf(Float(endPoint - startPoint)))
        let timeDelta = Double(fabsf(Float(endTime - startTime)))
        let speed = (distance / timeDelta) / 1000
        if speed > 5.0 {
            composerView.contentInput.resignFirstResponder()
        }
        lastOffsetCapture = endTime
        lastOffsetY = endPoint
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
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
            
            if tableView.contentSize.height + tableView.contentInset.bottom + tableView.contentInset.top > tableView.bounds.height {
                newMessageCount += 1
            }
        }
    }
    
    func workerDidUpdateTypingStatus(for personID: String, isTyping: Bool) {
        if isTyping {
            typingStatus[personID] = isTyping
            
        } else {
            typingStatus.removeValue(forKey: personID)
        }
    }
    
    func workerDidChangePresence(_ aPresence: Presence) {
        presence = aPresence
        updateTitleView()
        guard titleRefreshTimer == nil else {
            return
        }
        
        titleRefreshTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { [weak self] _ in
            self?.updateTitleView()
        })
        titleRefreshTimer?.fire()
    }
}

extension ConvoScene: ConvoSceneInteraction {
    
    func didTapBack() {
        worker.unlisteOnRecentMessage()
        worker.unlistenOnTypingStatus()
        worker.unlistenOnPresence()
        titleRefreshTimer?.invalidate()
        titleRefreshTimer = nil
        let _ = waypoint.exit()
    }
    
    func didTapSend() {
        worker.changeTypingStatus(false)
        let _ = worker.sendMessage(composerView.contentInput.text)
        composerView.updateContent("")
    }
    
    func didTapNewMessageCount() {
        scrollToBottom()
    }
    
    func didTapSetting() {
        let _ = flow.goToChatSetting(withChat: chat, delegate: self)
    }
}

extension ConvoScene: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        worker.changeTypingStatus(!textView.text.isEmpty)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return !isScrolling
    }
}

extension ConvoScene: ChatSettingSceneDelegate {
    
    func chatSettingSceneDidUpdateTitle(_ title: String) {
        titleView.nameLabel.text = title
        chat.title = title
    }
    
    func chatSettingSceneDidAddParticipant(_ person: Person) {
        
    }
    
    func chatSettingSceneDidRemoveParticipant(_ person: Person) {
        
    }
    
    func chatSettingSceneDidUpdateAvatar(withURL url: URL) {
        
    }
}
