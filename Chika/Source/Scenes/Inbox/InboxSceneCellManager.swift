//
//  InboxSceneCellManager.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol InboxSceneCellManager: class {
    
    var prototype: UITableViewCell? { get }
    
    func register(in tableView: UITableView)
    func dequeue() -> UITableViewCell?
}

extension InboxScene {
    
    class CellManager: InboxSceneCellManager {
        
        weak var tableView: UITableView?
        var cellClass: AnyClass
        var reuseID: String
        var prototype: UITableViewCell?
        
        init(cellClass: AnyClass = InboxSceneCell.self, reuseID: String = "InitialSceneCell", prototype: UITableViewCell = InboxSceneCell()) {
            self.cellClass = cellClass
            self.reuseID = reuseID
            self.prototype = prototype
        }
        
        func register(in tv: UITableView) {
            tableView = tv
            tableView?.register(cellClass, forCellReuseIdentifier: reuseID)
        }
        
        func dequeue() -> UITableViewCell? {
            return tableView?.dequeueReusableCell(withIdentifier: reuseID)
        }
    }
}
