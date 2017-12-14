//
//  AboutSceneCellFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol AboutSceneCellFactory: class {
    
    var prototype: UITableViewCell? { get }
    
    func build(using: UITableView, reuseID: String, theme: AboutSceneTheme) -> UITableViewCell
}

extension AboutScene {
    
    class CellFactory: AboutSceneCellFactory {
    
        var prototype: UITableViewCell?
    
        func build(using tableView: UITableView, reuseID: String, theme: AboutSceneTheme) -> UITableViewCell {
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseID)
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseID)
                cell.textLabel?.textColor = theme.labelTextColor
                cell.textLabel?.font = theme.labelFont
                cell.detailTextLabel?.textColor = theme.contentTextColor
                cell.detailTextLabel?.font = theme.contentFont
                cell.selectionStyle = .none
            }
            return cell
        }
    }
}
