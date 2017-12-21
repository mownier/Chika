//
//  ChatSettingScene.swift
//  Chika
//
//  Created Mounir Ybanez on 12/16/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol ChatSettingSceneInteraction: class {
    
    func didTapBack()
    func didTapEdit()
    func didTapEditCancel()
    func didTapEditOK()
}

protocol ChatSettingSceneDelegate: class {
    
    func chatSettingSceneDidUpdateTitle(_ title: String)
    func chatSettingSceneDidAddParticipants(_ persons: [Person])
    func chatSettingSceneDidRemoveParticipant(_ person: Person)
    func chatSettingSceneDidUpdateAvatar(withURL url: URL)
}

class ChatSettingScene: UIViewController {
    
    weak var delegate: ChatSettingSceneDelegate?
    
    var tableView: UITableView!
    var headerView: ChatSettingSceneHeaderView!
    
    var theme: ChatSettingSceneTheme
    var data: ChatSettingSceneData
    var worker: ChatSettingSceneWorker
    var flow: ChatSettingSceneFlow
    var setup: ChatSettingSceneSetup
    var cellFactory: ChatSettingSceneMultipleCellFactory
    var waypoint: AppExitWaypoint
    
    init(theme: ChatSettingSceneTheme,
        data: ChatSettingSceneData,
        worker: ChatSettingSceneWorker,
        flow: ChatSettingSceneFlow,
        setup: ChatSettingSceneSetup,
        cellFactory: ChatSettingSceneMultipleCellFactory,
        waypoint: AppExitWaypoint) {
        self.theme = theme
        self.data = data
        self.worker = worker
        self.flow = flow
        self.cellFactory = cellFactory
        self.setup = setup
        self.waypoint = waypoint
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(chat: Chat, participantShownLimit limit: UInt) {
        let theme = Theme()
        let data = Data(chat: chat, participantShownLimit: limit)
        let worker = Worker()
        let flow = Flow()
        let setup = Setup(theme: theme)
        let waypoint = ExitWaypoint()
        let cellFactory = MultipleCellFactory(theme: theme)
        self.init(theme: theme, data: data, worker: worker, flow: flow, setup: setup, cellFactory: cellFactory, waypoint: waypoint)
        worker.output = self
        flow.scene = self
        waypoint.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(chat: Chat(), participantShownLimit: 4)
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
        headerView = ChatSettingSceneHeaderView()
        headerView.avatar.backgroundColor = theme.avatarBGColor
        headerView.titleInput.tintColor = theme.tableHeaderTitleTextColor
        headerView.titleInput.textColor = theme.tableHeaderTitleTextColor
        headerView.titleInput.delegate = self
        headerView.titleInput.font = theme.tableHeaderTitleFont
        headerView.creatorLabel.textColor = theme.tableHeaderCreatorTextColor
        headerView.creatorLabel.font = theme.tableHeaderCreatorFont
        headerView.titleLabel.font = theme.tableHeaderTitleFont
        headerView.titleLabel.textColor = theme.tableHeaderTitleTextColor
        headerView.titleEditCancelButton.tintColor = theme.destructiveTextColor
        headerView.titleEditButton.tintColor = theme.tableHeaderTitleTextColor
        headerView.titleEditOKButton.tintColor = theme.positiveTextColor
        headerView.titleEditOKButton.addTarget(self, action: #selector(self.didTapEditOK), for: .touchUpInside)
        headerView.titleEditButton.addTarget(self, action: #selector(self.didTapEdit), for: .touchUpInside)
        headerView.titleEditCancelButton.addTarget(self, action: #selector(self.didTapEditCancel), for: .touchUpInside)
        headerView.titleEditButton.addTarget(self, action: #selector(self.didTapEdit), for: .touchUpInside)
        headerView.isEditing = false
        
        tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = 52
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = theme.bgColor
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = setup.formatTitle(in: navigationItem)
        let _ = setup.formatHeaderView(headerView, for: data.headerItem)
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "button_back"), style: .plain, target: self, action: #selector(self.didTapBack))
        navigationItem.leftBarButtonItem = back
    }
    
    override func viewDidLayoutSubviews() {
        var rect = CGRect.zero
        
        rect = view.bounds
        tableView.frame = rect
        
        rect.origin = .zero
        rect.size.width = tableView.frame.width
        rect.size.height = 240
        headerView.bounds = rect
        tableView.tableHeaderView = headerView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        headerView.titleInput.resignFirstResponder()
    }
    
    func showError(withMessage msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

extension ChatSettingScene: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.itemCount(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let reuseID = data.reuseID(in: section, at: row)
        let item = data.item(in: section, at: row)
        let cell = cellFactory.build(using: tableView, reuseID: reuseID, in: section, at: row)
        let _ = setup.format(cell: cell, item: item)
        return cell
    }
}

extension ChatSettingScene: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data.headerTitle(in: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return data.headerTitle(in: section) == nil ? 0 : 24
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 24 : 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return section == 0 ? UIView() : nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.textColor = theme.headerTextColor
        header.textLabel?.font = theme.headerFont
        header.backgroundView?.backgroundColor = theme.headerBGColor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        guard let item = data.item(in: section, at: row),
            (item is ChatSettingSceneOptionItem) ||
                (item is ChatSettingSceneMemberItem && (item as! ChatSettingSceneMemberItem).action != .none) else {
                    return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let memberItem = item as? ChatSettingSceneMemberItem else {
            return
        }
        
        if memberItem.action == .add {
            let _ = flow.goToContactSelector(withExcludedPersons: data.excludedPersons, delegate: self)
            return
        }
        
        if memberItem.action == .showMore || memberItem.action == .showLess {
            let (showState, indices) = data.toggleShowAction()
            let indexPaths: [IndexPath] = indices.map({ IndexPath(row: $0, section: 0) })
            let newCount = data.itemCount(in: 0)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                if newCount > 0 {
                    tableView.reloadRows(at: [IndexPath(row: newCount - 1, section: 0)], with: .fade)
                }
            }
            tableView.beginUpdates()
            
            switch showState {
            case .less:
                tableView.deleteRows(at: indexPaths, with: .top)
                
            case .more:
                tableView.insertRows(at: indexPaths, with: .bottom)
                
            case .none:
                break
            }
            
            tableView.endUpdates()
            CATransaction.commit()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        headerView.titleInput.resignFirstResponder()
    }
}

extension ChatSettingScene: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        headerView.isEditing = false
    }
}

extension ChatSettingScene: ChatSettingSceneInteraction {
    
    func didTapBack() {
        let _ = waypoint.exit()
    }
    
    func didTapEdit() {
        headerView.isEditing = true
        headerView.titleInput.text = data.chat.title
    }
    
    func didTapEditOK() {
        headerView.isEditing = false
        guard let title = headerView.titleInput.text, !title.isEmpty else {
            return
        }
        
        headerView.titleInput.text = ""
        let _ = setup.formatHeaderView(headerView, withTitle: title)
        tableView.tableHeaderView = headerView
        worker.updateTitle(of: data.chat.id, title: title)
    }
    
    func didTapEditCancel() {
        headerView.isEditing = false
    }
}

extension ChatSettingScene: ChatSettingSceneWorkerOutput {
    
    func workerDidUpdateTitle(_ title: String) {
        data.updateTitle(title)
        let _ = setup.formatHeaderView(headerView, for: data.headerItem)
        tableView.tableHeaderView = headerView
        delegate?.chatSettingSceneDidUpdateTitle(title)
    }
    
    func workerDidUpdateTitleWithError(_ error: Error) {
        let _ = setup.formatHeaderView(headerView, withTitle: data.chat.title)
        tableView.tableHeaderView = headerView
        showError(withMessage: "\(error)")
    }
    
    func workerDidAddPeople(_ people: [Person]) {
        let added = data.addParticipants(people)
        tableView.reloadData()
        delegate?.chatSettingSceneDidAddParticipants(added)
    }
    
    func worderDidAddPeopleWithError(_ error: Error) {
        showError(withMessage: "\(error)")
    }
}

extension ChatSettingScene: ContactSelectorSceneDelegate {
    
    func contactSelectorScene(_ scene: ContactSelectorScene, didSelectContacts contacts: [Contact]) {
        guard !contacts.isEmpty else { return }
        worker.addPeople(in: data.chat.id, people: contacts)
    }
}
