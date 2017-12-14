//
//  ProfileScene.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/8/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol ProfileSceneInteraction: class {

    func didTapEdit()
    func didTapRequests()
}

class ProfileScene: UIViewController {

    var theme: ProfileSceneTheme
    var worker: ProfileSceneWorker
    var data: ProfileSceneData
    var flow: ProfileSceneFlow
    var setup: ProfileSceneSetup
    var cellFactory: ProfileSceneCellFactory
    
    var headerView: ProfileSceneHeaderView!
    var tableView: UITableView!
    var editButton: UIButton!
    var requestsButton: UIButton!
    var badge: UILabel!
    
    var isAppeared: Bool = false
    
    init(theme: ProfileSceneTheme, worker: ProfileSceneWorker, data: ProfileSceneData, flow: ProfileSceneFlow, setup: ProfileSceneSetup, cellFactory: ProfileSceneCellFactory) {
        self.theme = theme
        self.worker = worker
        self.data = data
        self.flow = flow
        self.setup = setup
        self.cellFactory = cellFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let theme = Theme()
        let worker = Worker()
        let data = Data()
        let flow = Flow()
        let setup = Setup()
        let cellFactory = CellFactory()
        self.init(theme: theme, worker: worker, data: data, flow: flow, setup: setup, cellFactory: cellFactory)
        worker.output = self
        flow.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func loadView() {
        super.loadView()
    
        view.backgroundColor = theme.bgColor
        
        headerView = ProfileSceneHeaderView()
        headerView.avatar.backgroundColor = theme.avatarBGColor
        
        tableView = UITableView()
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = 64
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        editButton = UIButton()
        editButton.setImage(#imageLiteral(resourceName: "pencil_button"), for: .normal)
        editButton.addTarget(self, action: #selector(self.didTapEdit), for: .touchUpInside)
        editButton.tintColor = theme.actionTintColor
        editButton.backgroundColor = theme.actionBGColor
        editButton.layer.masksToBounds = true
        
        requestsButton = UIButton()
        requestsButton.setImage(#imageLiteral(resourceName: "contact_request_button"), for: .normal)
        requestsButton.addTarget(self, action: #selector(self.didTapRequests), for: .touchUpInside)
        requestsButton.tintColor = theme.actionTintColor
        requestsButton.backgroundColor = theme.actionBGColor
        requestsButton.layer.masksToBounds = true
        
        badge = UILabel()
        badge.textAlignment = .center
        badge.backgroundColor = theme.badgeBGColor
        badge.textColor = theme.badgeTextColor
        badge.font = theme.badgeFont
        badge.minimumScaleFactor = 0.5
        badge.layer.masksToBounds = true
        badge.isHidden = true
        
        view.addSubview(tableView)
        view.addSubview(editButton)
        view.addSubview(requestsButton)
        view.addSubview(badge)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem.badgeColor = theme.badgeBGColor
        worker.fetchProfile()
        worker.listenOnAddedContactRequests()
        worker.listenOnRemovedContactRequests()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarItem.badgeValue = nil
        isAppeared = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarItem.badgeValue = nil
        isAppeared = false
    }
    
    override func viewDidLayoutSubviews() {
        let spacing: CGFloat = 8
        
        var rect = CGRect.zero
        
        rect.size = view.bounds.size
        tableView.frame = rect
        
        rect.origin = .zero
        rect.size.width = tableView.frame.width
        rect.size.height = 180
        headerView.bounds = rect
        tableView.tableHeaderView = headerView
        
        rect.size.width = 44
        rect.size.height = rect.width
        rect.origin.y = view.statusBarFrame().height + spacing * 4
        rect.origin.x = spacing * 2
        editButton.frame = rect
        editButton.layer.cornerRadius = rect.width / 2
        
        rect.origin.x = view.bounds.width - rect.width - spacing * 2
        requestsButton.frame = rect
        requestsButton.layer.cornerRadius = rect.width / 2
        
        rect.size.width = 32
        rect.size.height = rect.width
        rect.origin.x = requestsButton.frame.origin.x - 16
        rect.origin.y = requestsButton.frame.origin.y - 8
        badge.frame = rect
        badge.layer.cornerRadius = rect.width / 2
    }
}

extension ProfileScene: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellFactory.build(using: tableView, reuseID: "Cell", theme: theme)
        let item = data.item(at: indexPath.row)
        let _ = setup.format(cell: cell, theme: theme, item: item)
        return cell
    }
}

extension ProfileScene: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = data.item(at: indexPath.row) else {
            return
        }
        
        if item.label.lowercased() == "sign out" {
            let actionSheet = UIAlertController(title: "Sign Out", message: "Are you sure?", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            actionSheet.addAction(okAction)
            actionSheet.addAction(cancelAction)
            actionSheet.view.tintColor = theme.labelTextColor
            
            present(actionSheet, animated: true, completion: nil)
        }
    }
}

extension ProfileScene: ProfileSceneWorkerOutput {
    
    func workerDidFetchProfile(_ person: Person) {
        data.updatePerson(person)
        tableView.reloadData()
    }
    
    func workerDidFetchProfileWithError(_ error: Error) {
        tableView.reloadData()
    }
    
    func workerDidReceiveContactRequest() {
        data.contactRequestCount += 1
        badge.text = "\(data.contactRequestCount)"
        badge.isHidden = false
        
        if !isAppeared {
            tabBarItem?.badgeValue = badge.text
        }
    }
    
    func workerDidRemoveContactRequest() {
        guard data.contactRequestCount > 0 else { return }
        data.contactRequestCount -= 1
        badge.text = data.contactRequestCount == 0 ? nil : "\(data.contactRequestCount)"
        badge.isHidden = data.contactRequestCount == 0
        
        if !isAppeared {
            tabBarItem?.badgeValue = badge.text
        }
    }
}

extension ProfileScene: ProfileSceneInteraction {
    
    func didTapEdit() {
        let _ = flow.goToProfileEdit(withPerson: data.person, delegate: self)
    }
    
    func didTapRequests() {
        let _ = flow.goToContactRequest()
    }
}

extension ProfileScene: ProfileEditSceneDelegate {
    
    func profileEditSceneDidEdit(withPerson person: Person) {
        data.updatePerson(person)
        tableView.reloadData()
    }
}
