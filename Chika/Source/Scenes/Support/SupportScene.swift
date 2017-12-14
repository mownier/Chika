//
//  SupportScene.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol SupportSceneInteraction: class {
    
    func didTapBack()
}

class SupportScene: UITableViewController {
    
    var theme: SupportSceneTheme
    var data: SupportSceneData
    var flow: SupportSceneFlow
    var setup: SupportSceneSetup
    var cellFactory: SupportSceneCellFactory
    var waypoint: AppExitWaypoint
    
    init(theme: SupportSceneTheme,
        data: SupportSceneData,
        flow: SupportSceneFlow,
        setup: SupportSceneSetup,
        cellFactory: SupportSceneCellFactory,
        waypoint: AppExitWaypoint) {
        self.theme = theme
        self.data = data
        self.flow = flow
        self.cellFactory = cellFactory
        self.setup = setup
        self.waypoint = waypoint
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let theme = Theme()
        let data = Data()
        let flow = Flow()
        let cellFactory = SupportScene.CellFactory()
        let setup = Setup()
        let waypoint = SupportScene.ExitWaypoint()
        self.init(theme: theme, data: data, flow: flow, setup: setup, cellFactory: cellFactory, waypoint: waypoint)
        waypoint.scene = self
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = setup.formatTitle(in: navigationItem)
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "button_back"), style: .plain, target: self, action: #selector(self.didTapBack))
        navigationItem.leftBarButtonItem = back
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.itemCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellFactory.build(using: tableView, reuseID: "Cell", theme: theme)
        let item = data.item(at: indexPath.row)
        let _ = setup.format(cell: cell, item: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = data.item(at: indexPath.row) else {
            return
        }
        
        flow.goToWebBrowser(withURL: item.url)
    }
}

extension SupportScene: SupportSceneInteraction {
    
    func didTapBack() {
        let _ = waypoint.exit()
    }
}
