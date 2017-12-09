//
//  ContactRequestScene.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol ContactRequestSceneInteraction: class {
    
    func didTapBack()
}

class ContactRequestScene: UIViewController {

    var theme: ContactRequestSceneTheme
    var data: ContactRequestSceneData
    var worker: ContactRequestSceneWorker
    var flow: ContactRequestSceneFlow
    var setup: ContactRequestSceneSetup
    var cellFactory: ContactRequestSceneCellFactory
    var waypoint: AppExitWaypoint
    
    init(theme: ContactRequestSceneTheme,
        data: ContactRequestSceneData,
        worker: ContactRequestSceneWorker,
        flow: ContactRequestSceneFlow,
        setup: ContactRequestSceneSetup,
        cellFactory: ContactRequestSceneCellFactory,
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
    
    convenience init() {
        let theme = Theme()
        let data = Data()
        let worker = Worker()
        let flow = Flow()
        let cellFactory = ContactRequestSceneCell.Factory()
        let setup = Setup()
        let waypoint = ContactRequestScene.ExitWaypoint()
        self.init(theme: theme, data: data, worker: worker, flow: flow, setup: setup, cellFactory: cellFactory, waypoint: waypoint)
        worker.output = self
        flow.scene = self
        waypoint.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        worker.fetchSentRequests()
        worker.fetchPendingRequests()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "button_back"), style: .plain, target: self, action: #selector(self.didTapBack))
        navigationItem.leftBarButtonItem = back
        
        let _ = setup.formatTitle(in: navigationItem)
    }
}

extension ContactRequestScene: ContactRequestSceneInteraction {
    
    func didTapBack() {
        let _ = waypoint.exit()
    }
}

extension ContactRequestScene: ContactRequestSceneWorkerOutput {

    func workerDidFetchSentRequests(_ requests: [Contact.Request]) {
        print("sent requests:", requests)
    }
    
    func workerDidFetchPendingRequests(_ requests: [Contact.Request]) {
        print("pending requests:", requests)
    }
    
    func workerDidFetchSentRequestsWithError(_ info: Error) {
        print("[err] sent requests:", info)
    }
    
    func workerDidFetchPendingRequestsWithError(_ info: Error) {
        print("[err] pending requests:", info)
    }
}
