

//
//  ProfileSceneCellFactory.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/8/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ProfileSceneCellFactory: class {

    var prototype: UITableViewCell? { get }
    
    func build(using: UITableView, reuseID: String, theme: ProfileSceneTheme) -> UITableViewCell
}

extension ProfileScene {
    
    class CellFactory: ProfileSceneCellFactory {
        
        var prototype: UITableViewCell?
        
        func build(using tableView: UITableView, reuseID: String, theme: ProfileSceneTheme) -> UITableViewCell {
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseID)
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseID)
                cell.textLabel?.font = theme.labelFont
                cell.detailTextLabel?.textColor = theme.contentTextColor
                cell.detailTextLabel?.font = theme.contentFont
                cell.detailTextLabel?.textAlignment = .right
                cell.selectionStyle = .none
            }
            return cell
        }
    }
}
