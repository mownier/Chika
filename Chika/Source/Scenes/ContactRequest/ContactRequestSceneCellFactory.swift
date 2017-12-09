//
//  ContactRequestSceneCellFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactRequestSceneCellFactory: class {
    
    var prototype: UITableViewCell? { get }
    
    func build(using: UITableView, reuseID: String, theme: ContactRequestSceneTheme) -> UITableViewCell
}

extension ContactRequestSceneCell {
    
    class Factory: ContactRequestSceneCellFactory {
    
        var prototype: UITableViewCell?
    
        func build(using tableView: UITableView, reuseID: String, theme: ContactRequestSceneTheme) -> UITableViewCell {
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseID)
            if cell == nil {
                let aCell =  ContactRequestSceneCell()
                cell = aCell
            }
            return cell
        }
    }
}
