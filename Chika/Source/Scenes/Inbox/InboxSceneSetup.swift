//
//  InboxSceneSetup.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/20/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import DateTools

protocol InboxSceneSetup: class {

    func format(cell: UITableViewCell?, theme: InboxSceneTheme, item: InboxSceneItem?, isLast: Bool) -> Bool
    func height(for cell: UITableViewCell?, theme: InboxSceneTheme, item: InboxSceneItem?, isLast: Bool) -> CGFloat
}

extension InboxScene {
    
    class Setup: InboxSceneSetup {
        
        func format(cell: UITableViewCell?, theme: InboxSceneTheme, item: InboxSceneItem?, isLast: Bool) -> Bool {
            guard let cell = cell as? InboxSceneCell, let item = item else {
                return false
            }
            
            cell.chatTitleLabel.font = theme.chatTitleFont
            cell.chatTitleLabel.textColor = theme.chatTitleTextColor
            cell.chatRecentMessageLabel.font = theme.chatRecentMessageFont
            cell.chatRecentMessageLabel.textColor = theme.chatRecentMessageTextColor
            cell.timeLabel.textColor = theme.chatTimeTextColor
            cell.timeLabel.font = theme.chatTimeFont
            cell.strip.backgroundColor = isLast ? UIColor.clear : theme.stripColor
            cell.unreadMessageCountLabel.textColor = theme.unreadMessageCountTextColor
            cell.unreadMessageCountLabel.backgroundColor = theme.unreadMessageBGColor
            cell.unreadMessageCountLabel.font = theme.unreadMessaegCountFont
            cell.onlineStatusView.backgroundColor = theme.onlineStatusColor
            
            cell.chatTitleLabel.text = item.chat.title
            cell.chatRecentMessageLabel.text = item.typingText.isEmpty ? item.chat.recent.content : item.typingText
            cell.avatarView.style = InboxSceneCellAvatar.Style(count: UInt(item.chat.participants.count))
            cell.timeLabel.text = "\((item.chat.recent.date as NSDate).timeAgoSinceNow()!)".lowercased()
            cell.unreadMessageCountLabel.text = item.unreadMessageCount == 0 ? "" : "\(item.unreadMessageCount)"
            cell.onlineStatusView.isHidden = !item.isSomeoneOnline
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return true
        }
        
        func height(for cell: UITableViewCell?, theme: InboxSceneTheme, item: InboxSceneItem?, isLast: Bool) -> CGFloat {
            guard format(cell: cell, theme: theme, item: item, isLast: isLast) else {
                return 0
            }
            
            let chatCell = cell as! InboxSceneCell
            return max(chatCell.avatarView.frame.maxY, chatCell.chatRecentMessageLabel.frame.maxY) + chatCell.avatarView.frame.origin.y
        }
    }
}
