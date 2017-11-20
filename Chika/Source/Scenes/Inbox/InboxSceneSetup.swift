//
//  InboxSceneSetup.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol InboxSceneSetup: class {

    func format(cell: UITableViewCell?, theme: InboxSceneTheme, chat: Chat?) -> Bool
    func height(for cell: UITableViewCell?, theme: InboxSceneTheme, chat: Chat?) -> CGFloat
}

extension InboxScene {
    
    class Setup: InboxSceneSetup {
        
        func format(cell: UITableViewCell?, theme: InboxSceneTheme, chat: Chat?) -> Bool {
            guard let cell = cell as? InboxSceneCell, let chat = chat else {
                return false
            }
            
            cell.chatTitleLabel.font = theme.chatTitleLabelFont
            cell.chatRecentMessageLabel.font = theme.chatRecentMessageLabelFont
            cell.chatTitleLabel.text = chat.title
            cell.chatRecentMessageLabel.text = chat.recent.content
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return true
        }
        
        func height(for cell: UITableViewCell?, theme: InboxSceneTheme, chat: Chat?) -> CGFloat {
            guard format(cell: cell, theme: theme, chat: chat) else {
                return 0
            }
            
            let chatCell = cell as! InboxSceneCell
            return chatCell.chatRecentMessageLabel.frame.maxY + chatCell.chatTitleLabel.frame.origin.y
        }
    }
}
