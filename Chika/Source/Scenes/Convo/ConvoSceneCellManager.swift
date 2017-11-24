//
//  ConvoSceneCellManager.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/24/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ConvoSceneCellManager: class {
    
    var leftPrototype: UITableViewCell? { get }
    var rightPrototype: UITableViewCell? { get }
    
    func assignTableView(_ tableView: UITableView)
    func registerLeftCell()
    func registerRightCell()
    func dequeueLeftCell() -> UITableViewCell?
    func dequeueRightCell() -> UITableViewCell?
}

extension ConvoScene {
    
    class CellManager: ConvoSceneCellManager {
        
        struct Prototype {
            
            var right: UITableViewCell?
            var left: UITableViewCell?
        }
        
        struct ReuseID {
            
            var right: String = ""
            var left: String = ""
        }
        
        weak var tableView: UITableView?
        var cellClass: AnyClass
        var reuseID: ReuseID
        var prototype: Prototype
        
        var leftPrototype: UITableViewCell? {
            return prototype.left
        }
        
        var rightPrototype: UITableViewCell? {
            return prototype.right
        }
        
        init(cellClass: AnyClass, prototype: Prototype, reuseID: ReuseID) {
            self.cellClass = cellClass
            self.reuseID = reuseID
            self.prototype = prototype
        }
        
        convenience init() {
            let cell = ConvoSceneCell.self
            let right = ConvoSceneCell(reuseID: ConvoSceneCell.ReuseID.right)
            let left = ConvoSceneCell(reuseID: ConvoSceneCell.ReuseID.left)
            let prototype = Prototype(right: right, left: left)
            let rightID = ConvoSceneCell.ReuseID.right.rawValue
            let leftID = ConvoSceneCell.ReuseID.left.rawValue
            let reuseID = ReuseID(right: rightID, left: leftID)
            self.init(cellClass: cell, prototype: prototype, reuseID: reuseID)
        }
        
        func assignTableView(_ tv: UITableView) {
            tableView = tv
        }
        
        func registerLeftCell() {
            tableView?.register(cellClass, forCellReuseIdentifier: reuseID.left)
        }
        
        func registerRightCell() {
            tableView?.register(cellClass, forCellReuseIdentifier: reuseID.right)
        }
        
        func dequeueLeftCell() -> UITableViewCell? {
            return tableView?.dequeueReusableCell(withIdentifier: reuseID.left)
        }
        
        func dequeueRightCell() -> UITableViewCell? {
            return tableView?.dequeueReusableCell(withIdentifier: reuseID.right)
        }
    }
}

