//
//  ContactsScene.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/4/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol ContactsSceneInteraction {
    
    func didTapSearchCancel()
    func didTapSearchIcon()
    func keyboardWillShow()
    func keyboardWillHide()
}

class ContactsScene: UIViewController {

    var searchView: ContactsSceneSearchView!
    var searchResultTableView: UITableView!
    var searchResultEmptyView: ContactsSceneSearchResultEmptyView!
    var tableView: UITableView!
    
    var theme: ContactsSceneTheme
    var data: ContactsSceneData
    var worker: ContactsSceneWorker
    var cellFactory: ContactsSceneCellFactory
    var flow: ContactsSceneFlow
    var setup: ContactsSceneSetup
    var searchResultData: ContactsSceneData
    
    var notifCenter: NotificationCenter = .default
    
    var isPopoverShown: Bool = false
    var isSearchEnabled: Bool = false {
        didSet {
            guard isSearchEnabled != oldValue else {
                return
            }
            
            searchView.isSearching = isSearchEnabled
            
            if isSearchEnabled {
                showSearchResultTableView { }
            
            } else {
                hideSearchResultTableView { [weak self] in
                    self?.searchResultData.removeAll()
                    self?.searchResultTableView.reloadData()
                    self?.searchResultTableView.backgroundView = nil
                    self?.searchView.searchInput.text = ""
                }
            }
        }
    }
    
    init(theme: ContactsSceneTheme, data: ContactsSceneData, worker: ContactsSceneWorker, flow: ContactsSceneFlow, cellFactory: ContactsSceneCellFactory, setup: ContactsSceneSetup, searchResultData: ContactsSceneData) {
        self.theme = theme
        self.data = data
        self.worker = worker
        self.flow = flow
        self.cellFactory = cellFactory
        self.setup = setup
        self.searchResultData = searchResultData
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let theme = Theme()
        let data = Data()
        let worker = Worker()
        let flow = Flow()
        let cellFactory = ContactsSceneCell.Factory()
        let setup = Setup()
        let searchResultData = Data()
        self.init(theme: theme, data: data, worker: worker, flow: flow, cellFactory: cellFactory, setup: setup, searchResultData: searchResultData)
        worker.output = self
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
        tableView.backgroundColor = theme.bgColor
        
        searchResultTableView = UITableView()
        searchResultTableView.tableFooterView = UIView()
        searchResultTableView.separatorStyle = .none
        searchResultTableView.estimatedRowHeight = 0
        searchResultTableView.rowHeight = 0
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.backgroundColor = theme.bgColor
        searchResultTableView.alpha = 0.0
        
        searchView = ContactsSceneSearchView()
        searchView.backgroundColor = theme.searchBGColor
        searchView.searchInput.font = theme.searchInputFont
        searchView.searchInput.textColor = theme.searchInputTextColor
        searchView.searchInput.tintColor = theme.searchInputTextColor
        searchView.strip.backgroundColor = theme.searchStripColor
        searchView.searchInput.delegate = self
        searchView.searchButton.tintColor = theme.searchButtonTintColor
        searchView.cancelButton.tintColor = theme.searchButtonTintColor
        searchView.cancelButton.setTitleColor(theme.searchCancelButtonTextColor, for: .normal)
        searchView.cancelButton.titleLabel?.font = theme.searchCancelButtonFont
        searchView.searchButton.addTarget(self, action: #selector(self.didTapSearchIcon), for: .touchUpInside)
        searchView.cancelButton.addTarget(self, action: #selector(self.didTapSearchCancel), for: .touchUpInside)
        
        searchResultEmptyView = ContactsSceneSearchResultEmptyView()
        searchResultEmptyView.titleLabel.text = "No results found"
        searchResultEmptyView.titleLabel.textColor = theme.searchResultEmptyTitleTextColor
        searchResultEmptyView.titleLabel.font = theme.searchResultEmptyTitleFont
        
        view.addSubview(tableView)
        view.addSubview(searchView)
        view.addSubview(searchResultTableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        worker.fetchContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardObserer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
    }
    
    override func viewDidLayoutSubviews() {
        cellFactory.prototype?.bounds.size.width = view.bounds.width
        
        let topInset: CGFloat = view.statusBarFrame().height
        
        var rect = CGRect.zero
        
        rect.size.height = 59 + topInset
        rect.size.width = view.bounds.width
        searchView.frame = rect
    
        rect.origin.y = rect.maxY
        rect.size.height = view.bounds.height - rect.origin.y
        tableView.frame = rect
        searchResultTableView.frame = rect
        searchResultEmptyView.frame = searchResultTableView.bounds
    }
    
    func showSearchResultTableView(_ completion: @escaping () -> Void) {
        let tableView = searchResultTableView
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn) {
            tableView?.alpha = 1.0
        }
        animator.addCompletion { position in
            switch position {
            case .end:
                completion()
                
            default:
                break
            }
        }
        
        DispatchQueue.main.async {
            animator.startAnimation()
        }
    }
    
    func hideSearchResultTableView(_ completion: @escaping () -> Void) {
        let tableView = searchResultTableView
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeOut) {
            tableView?.alpha = 0.0
        }
        animator.addCompletion { position in
            switch position {
            case .end:
                completion()
                
            default:
                break
            }
        }
        
        DispatchQueue.main.async {
            animator.startAnimation()
        }
    }
    
    func addKeyboardObserer() {
        notifCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        notifCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardObserver() {
        notifCenter.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        notifCenter.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    var isKeyboardShown: Bool = false
    var prevBottomOffset: CGFloat = 0
    var timer: Timer?
}

extension ContactsScene: ContactsSceneInteraction {
    
    func didTapSearchIcon() {
        searchView.searchInput.becomeFirstResponder()
    }
    
    func didTapSearchCancel() {
        isSearchEnabled = false
        searchView.searchInput.resignFirstResponder()
    }
    
    func keyboardWillHide() {
        isKeyboardShown = false
        
        timer?.invalidate()
        timer = nil
        
        searchResultTableView.contentInset.bottom = prevBottomOffset
        searchResultTableView.scrollIndicatorInsets.bottom = prevBottomOffset
    }
    
    func keyboardWillShow() {
        guard !isKeyboardShown else {
            return
        }
        
        isKeyboardShown = true
        prevBottomOffset = searchResultTableView.contentInset.bottom
        
        let keyboardSize = UIApplication.shared.windows[1].subviews[0].subviews[0].bounds.size
        let prevBottom = searchResultTableView.contentInset.bottom
        let newBottom = prevBottomOffset + keyboardSize.height - (view.safeAreaInsets.top == 20 ? 49 : view.safeAreaInsets.top == 44 ? 83 : 0)
        if newBottom != prevBottom {
            searchResultTableView.contentInset.bottom = newBottom + 42
            searchResultTableView.scrollIndicatorInsets.bottom = newBottom
        }
    }
}

extension ContactsScene: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let source = tableView == searchResultTableView ? searchResultData : data
        return source.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let source = tableView == searchResultTableView ? searchResultData : data
        let action = tableView == searchResultTableView ? self : nil
        let cell = cellFactory.build(using: tableView, reuseID: "ContactsSceneCell", theme: theme)
        let item = source.item(at: indexPath.row)
        let _ = setup.format(cell: cell, theme: theme, item: item, action: action)
        return cell
    }
}

extension ContactsScene: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let source = tableView == searchResultTableView ? searchResultData : data
        let action = tableView == searchResultTableView ? self : nil
        let item = source.item(at: indexPath.row)
        return setup.height(for: cellFactory.prototype, theme: theme, item: item, action: action)
    }
}

extension ContactsScene: ContactsSceneWorkerOutput {

    func workerDidFetch(contacts: [Person]) {
        data.removeAll()
        data.append(list: contacts)
        tableView.reloadData()
        
        for person in contacts {
            worker.listenOnActiveStatus(for: person.id)
        }
        
        worker.listenOnAddedContact()
        worker.listenOnRemovedContact()
    }
    
    func workerDidFetchWithError(_ error: Error) {
        tableView.reloadData()
    }
    
    func workerDidChangeActiveStatus(for personID: String, isActive: Bool) {
        guard let row = data.updateActiveStatus(for: personID, isActive: isActive) else {
            return
        }
        
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func workerDidAddContact(_ contact: Person) {
        data.append(list: [contact])
        tableView.reloadData()
        worker.listenOnActiveStatus(for: contact.id)
    }
    
    func workerDidRemoveContact(_ personID: String) {
        data.remove(personID)
        tableView.reloadData()
        worker.unlistenOnActiveStatus(for: personID)
    }
    
    func workerDidSearchPersonsToAdd(persons: [Person]) {
        searchResultData.removeAll()
        searchResultTableView.backgroundView = nil
        searchResultData.append(list: persons)
        searchResultTableView.reloadData()
    }
    
    func workerDidSearchPersonsToAddWithError(_ error: Error) {
        searchResultData.removeAll()
        searchResultTableView.backgroundView = searchResultEmptyView
        searchResultTableView.reloadData()
    }
    
    func workerDidRequestContactWithError(_ error: Error, personID: String) {
        let _ = searchResultData.updateRequestStatus(for: personID, status: .failed)
        searchResultTableView.reloadData()
    }
    
    func workerDidRequestContactOK(_ personID: String) {
        let _ = searchResultData.updateRequestStatus(for: personID, status: .sent)
        searchResultTableView.reloadData()
    }
}

extension ContactsScene: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        worker.searchPersonsToAdd(with: textField.text)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isSearchEnabled = true
    }
}

extension ContactsScene: ContactsSceneCellAction {
    
    func contactsSceneCellWillAddContact(_ cell: UITableViewCell) {
        guard let index = searchResultTableView.indexPath(for: cell),
            let person = searchResultData.item(at: index.row)?.person else {
                return
        }
        
        isPopoverShown = true
        
        let vc = ContactsSceneAddPopover(person: person)
        vc.delegate = self
        
        let sourceView = (cell as? ContactsSceneCell)?.avatar
        let controller = vc.popoverPresentationController
        controller?.sourceView = sourceView
        controller?.sourceRect = sourceView == nil ? .zero : sourceView!.bounds
        controller?.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension ContactsScene: UIPopoverPresentationControllerDelegate {
    
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

extension ContactsScene: ContactsSceneAddPopoverDelegate {
    
    func addPopoverDidOK(message: String, person: Person) {
        isPopoverShown = false
        let _ = searchResultData.updateRequestStatus(for: person.id, status: .sending)
        searchResultTableView.reloadData()
        worker.sendContactRequest(to: person.id, message: message)
    }
    
    func addPopoverDidCancel() {
        isPopoverShown = false
    }
}
