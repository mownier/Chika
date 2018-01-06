//
//  AboutScene.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TNCore

@objc protocol AboutSceneInteraction: class {
    
    func didTapBack()
}

class AboutScene: UITableViewController {
    
    var theme: AboutSceneTheme
    var data: AboutSceneData
    var setup: AboutSceneSetup
    var cellFactory: AboutSceneCellFactory
    var waypoint: ExitWaypoint
    
    init(theme: AboutSceneTheme,
        data: AboutSceneData,
        setup: AboutSceneSetup,
        cellFactory: AboutSceneCellFactory,
        waypoint: ExitWaypoint) {
        self.theme = theme
        self.data = data
        self.cellFactory = cellFactory
        self.setup = setup
        self.waypoint = waypoint
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let theme = Theme()
        let data = Data()
        let cellFactory = CellFactory()
        let setup = Setup()
        let waypoint = PushWaypointSource()
        self.init(theme: theme, data: data, setup: setup, cellFactory: cellFactory, waypoint: waypoint)
        //waypoint.scene = self
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
        let _ = setup.format(cell: cell, theme: theme, item: item)
        return cell
    }
}

extension AboutScene: AboutSceneInteraction {
    
    func didTapBack() {
        let _ = waypoint.exit()
    }
}
