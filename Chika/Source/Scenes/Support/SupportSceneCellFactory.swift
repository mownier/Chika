//
//  SupportSceneCellFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol SupportSceneCellFactory: class {
    
    var prototype: UITableViewCell? { get }
    
    func build(using: UITableView, reuseID: String, theme: SupportSceneTheme) -> UITableViewCell
}

extension SupportScene {
    
    class CellFactory: SupportSceneCellFactory {
    
        var prototype: UITableViewCell?
    
        func build(using tableView: UITableView, reuseID: String, theme: SupportSceneTheme) -> UITableViewCell {
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseID)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: reuseID)
                cell.textLabel?.textColor = theme.labelTextColor
                cell.textLabel?.font = theme.labelFont
                cell.selectionStyle = .none
                cell.accessoryType = .disclosureIndicator
            }
            return cell
        }
    }
}
