//
//  ProfileEditSceneCellFactory.swift
//  Chika
//
//  Created Mounir Ybanez on 12/13/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ProfileEditSceneCellFactory: class {
    
    var prototype: UITableViewCell? { get }
    
    func build(using: UITableView, reuseID: String, theme: ProfileEditSceneTheme) -> UITableViewCell
}

extension ProfileEditSceneCell {
    
    class Factory: ProfileEditSceneCellFactory {
    
        var prototype: UITableViewCell?
    
        func build(using tableView: UITableView, reuseID: String, theme: ProfileEditSceneTheme) -> UITableViewCell {
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseID)
            if cell == nil {
                let aCell =  ProfileEditSceneCell()
                cell = aCell
            }
            return cell
        }
    }
}
