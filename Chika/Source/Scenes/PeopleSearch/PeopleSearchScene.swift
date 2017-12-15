//
//  PeopleSearchScene.swift
//  Chika
//
//  Created Mounir Ybanez on 12/12/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol PeopleSearchSceneInteraction: class {
    
    func didTapSearchIcon()
    func didTapSearchCancel()
    func keyboardWillShow()
    func keyboardWillHide()
}

protocol PeopleSearchSceneDelegate: class {
    
    func peopleSearchSceneDidBeginSearching()
    func peopleSearchSceneDidEndSearching()
}

class PeopleSearchScene: UIViewController {

    weak var delegate: PeopleSearchSceneDelegate?
    
    var tableView: UITableView!
    var input: PeopleSearchSceneInput!
    var emptyView: PeopleSearchSceneEmptyView!
    
    var theme: PeopleSearchSceneTheme
    var data: PeopleSearchSceneData
    var worker: PeopleSearchSceneWorker
    var flow: PeopleSearchSceneFlow
    var setup: PeopleSearchSceneSetup
    var cellFactory: PeopleSearchSceneCellFactory
    
    var notifCenter: NotificationCenter = .default
    var isKeyboardShown: Bool = false
    var isPopoverShown: Bool = false
    var prevBottomOffset: CGFloat = 0
    
    init(theme: PeopleSearchSceneTheme,
        data: PeopleSearchSceneData,
        worker: PeopleSearchSceneWorker,
        flow: PeopleSearchSceneFlow,
        setup: PeopleSearchSceneSetup,
        cellFactory: PeopleSearchSceneCellFactory) {
        self.theme = theme
        self.data = data
        self.worker = worker
        self.flow = flow
        self.cellFactory = cellFactory
        self.setup = setup
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let theme = Theme()
        let data = Data()
        let worker = Worker()
        let flow = Flow()
        let cellFactory = PeopleSearchSceneCell.Factory()
        let setup = Setup()
        self.init(theme: theme, data: data, worker: worker, flow: flow, setup: setup, cellFactory: cellFactory)
        worker.output = self
        flow.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
        tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        
        input = PeopleSearchSceneInput()
        input.backgroundColor = theme.inputBGColor
        input.searchInput.font = theme.inputFont
        input.searchInput.textColor = theme.inputTextColor
        input.searchInput.tintColor = theme.inputTextColor
        input.strip.backgroundColor = theme.inputStripColor
        input.indicator.tintColor = theme.inputButtonTintColor
        input.searchInput.delegate = self
        input.searchButton.tintColor = theme.inputButtonTintColor
        input.cancelButton.tintColor = theme.inputButtonTintColor
        input.cancelButton.setTitleColor(theme.inputCancelButtonTextColor, for: .normal)
        input.cancelButton.titleLabel?.font = theme.inputCancelButtonFont
        input.searchButton.addTarget(self, action: #selector(self.didTapSearchIcon), for: .touchUpInside)
        input.cancelButton.addTarget(self, action: #selector(self.didTapSearchCancel), for: .touchUpInside)
        
        emptyView = PeopleSearchSceneEmptyView()
        emptyView.titleLabel.text = "No results found"
        emptyView.titleLabel.textColor = theme.emptyTitleTextColor
        emptyView.titleLabel.font = theme.emptyTitleFont
        
        view.addSubview(input)
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        cellFactory.prototype?.bounds.size.width = view.bounds.width
        
        let topInset: CGFloat = view.statusBarFrame().height
        
        var rect = CGRect.zero
        
        rect.size.height = 59 + topInset
        rect.size.width = view.bounds.width
        input.frame = rect
        
        rect.origin.y = rect.maxY
        rect.size.height = view.bounds.height - rect.origin.y
        tableView.frame = rect
        emptyView.frame = tableView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardObserer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
    }
    
    func addKeyboardObserer() {
        notifCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        notifCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardObserver() {
        notifCenter.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        notifCenter.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}

extension PeopleSearchScene: PeopleSearchSceneInteraction {
    
    func keyboardWillShow() {
        guard !isKeyboardShown else { return }
        
        isKeyboardShown = true
        prevBottomOffset = tableView.contentInset.bottom
        
        let keyboardSize = UIApplication.shared.windows[1].subviews[0].subviews[0].bounds.size
        let prevBottom = tableView.contentInset.bottom
        let newBottom = prevBottomOffset + keyboardSize.height - (view.safeAreaInsets.top == 20 ? 49 : view.safeAreaInsets.top == 44 ? 83 : 0)
        if newBottom != prevBottom {
            tableView.contentInset.bottom = newBottom + 42
            tableView.scrollIndicatorInsets.bottom = newBottom
        }
    }
    
    func keyboardWillHide() {
        isKeyboardShown = false
        
        tableView.contentInset.bottom = prevBottomOffset
        tableView.scrollIndicatorInsets.bottom = prevBottomOffset
    }
    
    func didTapSearchIcon() {
        input.searchInput.becomeFirstResponder()
    }
    
    func didTapSearchCancel() {
        input.isSearching = false
        input.isRequesting = false
        input.searchInput.text = ""
        input.searchInput.resignFirstResponder()
        data.removeAll()
        tableView.backgroundView = nil
        tableView.reloadData()
        worker.unlistenAll()
        delegate?.peopleSearchSceneDidEndSearching()
    }
}

extension PeopleSearchScene: PeopleSearchSceneWorkerOutput {
    
    func workerDidChangeActiveStatus(for personID: String, isActive: Bool) {
        guard let row = data.updateActiveStatus(for: personID, isActive: isActive) else {
            return
        }
        
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func workerDidRequestContactWithError(_ error: Error, personID: String) {
        guard let row = data.updateRequestStatus(for: personID, status: .retry) else {
            return
        }
        
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func workerDidRequestContactOK(_ personID: String) {
        guard let row = data.updateRequestStatus(for: personID, status: .sent) else {
            return
        }
        
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func workerDidSearchPeopleWithObjects(_ objects: [PersonSearchObject]) {
        guard input.isRequesting else { return }
        input.isRequesting = false
        data.removeAll()
        tableView.backgroundView = nil
        data.appendItems(objects)
        tableView.reloadData()
        
        worker.unlistenAll()
        let personIDs: [String] = objects.filter({ $0.isContact }).map({ $0.person.id })
        worker.listenOnActiveStatus(for: personIDs)
        worker.listenOnAddedContact()
        worker.listenOnRemovedContact()
        worker.listenOnIgnoredContactRequest()
        worker.listenOnReceivedContactRequest()
    }
    
    func workerDidSearchPeopleWithError(_ error: Error) {
        input.isRequesting = false
        data.removeAll()
        tableView.backgroundView = emptyView
        tableView.reloadData()
    }
    
    func workerDidAddContact(person: Person, chat: Chat) {
        guard let row = data.updateAsAddedContact(person: person, chat: chat) else {
            return
        }
        
        worker.listenOnActiveStatus(for: [person.id])
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func workerDidRemoveContact(withPersonID personID: String) {
        guard let row = data.updateAsRemovedContact(for: personID) else {
            return
        }
        
        worker.unlistenOnActiveStatus(for: [personID])
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func workerDidReceiveContactRequest(from personID: String) {
        guard let row = data.updateOnReceivedContactRequest(from: personID) else {
            return
        }
        
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func workerDidIgnoreContactRequest(by personID: String) {
        guard let row = data.updateOnIgnoredContactRequest(by: personID) else {
            return
        }
        
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
}

extension PeopleSearchScene: PeopleSearchSceneCellAction {
    
    func peopleSearchSceneCellWillAddContact(_ cell: UITableViewCell) {
        guard let index = tableView.indexPath(for: cell),
            let item = data.item(at: index.row) else {
                return
        }
        
        switch item.requestStatus {
        case .none, .retry:
            isPopoverShown = true
            
            let vc = ContactsSceneAddPopover(person: item.object.person)
            vc.delegate = self
            
            let sourceView = (cell as? PeopleSearchSceneCell)?.avatar
            let controller = vc.popoverPresentationController
            controller?.sourceView = sourceView
            controller?.sourceRect = sourceView == nil ? .zero : sourceView!.bounds
            controller?.delegate = self
            present(vc, animated: true, completion: nil)
        
        case .pending:
            let _ = flow.goToContactRequest()
        
        default:
            break
        }
    }
}

extension PeopleSearchScene: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellFactory.build(using: tableView, reuseID: "PeopleSearchSceneCell", theme: theme)
        let item = data.item(at: indexPath.row)
        let _ = setup.format(cell: cell, theme: theme, item: item, action: self)
        return cell
    }
}

extension PeopleSearchScene: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = data.item(at: indexPath.row)
        return setup.height(for: cellFactory.prototype, theme: theme, item: item, action: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = data.item(at: indexPath.row), item.object.isContact else {
            return
        }
        
        let _ = flow.goToConvo(withChat: item.object.chat)
    }
}

extension PeopleSearchScene: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        input.isRequesting = true
        worker.searchPeople(withKeyword: textField.text)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        input.isSearching = true
        delegate?.peopleSearchSceneDidBeginSearching()
    }
}

extension PeopleSearchScene: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        isPopoverShown = false
    }
}

extension PeopleSearchScene: ContactsSceneAddPopoverDelegate {
    
    func addPopoverDidOK(message: String, person: Person) {
        guard let item = data.item(for: person.id),
            !item.object.isPending,
            !item.object.isRequested else {
            return
        }
        
        isPopoverShown = false
        
        guard let row = data.updateRequestStatus(for: person.id, status: .sending) else {
            return
        }
        
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
        worker.sendContactRequest(to: person.id, message: message)
    }
    
    func addPopoverDidCancel() {
        isPopoverShown = false
    }
}
