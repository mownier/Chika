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
}

protocol ChatSettingSceneDelegate: class {
    
    func chatSettingSceneDidUpdateTitle(_ title: String)
    func chatSettingSceneDidAddParticipant(_ person: Person)
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
    
    convenience init(chat: Chat) {
        let theme = Theme()
        let data = Data(chat: chat)
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
        self.init(chat: Chat())
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
        headerView = ChatSettingSceneHeaderView()
        headerView.avatar.backgroundColor = theme.avatarBGColor
        headerView.titleInput.tintColor = theme.tableHeaderTitleTextColor
        headerView.titleInput.textColor = theme.tableHeaderTitleTextColor
        headerView.titleInput.font = theme.tableHeaderTitleFont
        headerView.creatorLabel.textColor = theme.tableHeaderCreatorTextColor
        headerView.creatorLabel.font = theme.tableHeaderCreatorFont
        
        tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = 59
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
        return setup.headerHeight(title: data.headerTitle(in: section))
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
                (item is ChatSettingSceneMemberItem && (item as! ChatSettingSceneMemberItem).isAddAction) else {
                    return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        headerView.titleInput.resignFirstResponder()
    }
}

extension ChatSettingScene: ChatSettingSceneInteraction {
    
    func didTapBack() {
        let _ = waypoint.exit()
    }
}

extension ChatSettingScene: ChatSettingSceneWorkerOutput {
    
}
