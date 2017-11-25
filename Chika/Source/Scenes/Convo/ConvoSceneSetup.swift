//
//  ConvoSceneSetup.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/24/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol ConvoSceneSetup: class {

    func formatCell(using cellManager: ConvoSceneCellManager, theme: ConvoSceneTheme, message: Message?, prevMessage: Message?) -> UITableViewCell
    func cellHeight(using cellManager: ConvoSceneCellManager, theme: ConvoSceneTheme, message: Message?, prevMessage: Message?) -> CGFloat
}

extension ConvoScene {
    
    class Setup: ConvoSceneSetup {
        
        var meID: String
        var dateFormatter: DateFormatter
        
        init(meID: String, dateFormatter: DateFormatter) {
            self.meID = meID
            self.dateFormatter = dateFormatter
        }
        
        convenience init(user: User? = Auth.auth().currentUser) {
            let meID = user?.uid ?? ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
            dateFormatter.pmSymbol = "PM"
            dateFormatter.amSymbol = "AM"
            self.init(meID: meID, dateFormatter: dateFormatter)
        }
        
        func formatCell(using cellManager: ConvoSceneCellManager, theme: ConvoSceneTheme, message: Message?, prevMessage: Message?) -> UITableViewCell {
            guard let message = message else {
                return ConvoSceneCell(reuseID: .left)
            }
        
            var cell: ConvoSceneCell
            let isRight: Bool = meID == message.author.id
            
            if isRight {
                var messageCell = cellManager.dequeueRightCell() as? ConvoSceneCell
                if messageCell == nil {
                    messageCell = ConvoSceneCell(reuseID: .right)
                }
                cell = messageCell!
                
            } else {
                var messageCell = cellManager.dequeueLeftCell() as? ConvoSceneCell
                if messageCell == nil {
                    messageCell = ConvoSceneCell(reuseID: .left)
                }
                cell = messageCell!
            }
            
            
            setup(cell, theme, message, prevMessage, isRight)
            return cell
        }
        
        func cellHeight(using cellManager: ConvoSceneCellManager, theme: ConvoSceneTheme, message: Message?, prevMessage: Message?) -> CGFloat {
            guard let message = message else {
                return 0
            }
            
            let cell: ConvoSceneCell
            let isRight: Bool = meID == message.author.id
            
            if isRight {
                guard let messageCell = cellManager.rightPrototype as? ConvoSceneCell else {
                    return 0
                }
                
                cell = messageCell
                
            } else {
                guard let messageCell = cellManager.leftPrototype as? ConvoSceneCell else {
                    return 0
                }
                
                cell = messageCell
            }
            
            setup(cell, theme, message, prevMessage, isRight)
            
            if isRight {
                return cell.timeLabel.frame.maxY + cell.contentBGView.frame.origin.y
            } else {
                return cell.timeLabel.frame.maxY + cell.avatarImageView.frame.origin.y
            }
        }
        
        private func setup(_ cell: ConvoSceneCell, _ theme: ConvoSceneTheme, _ message: Message, _ prevMessage: Message?, _ isRight: Bool) {
            if isRight {
                cell.contentLabel.textColor = theme.rightCellContentTextColor
                cell.contentBGView.backgroundColor = theme.rightCellContenBGColor
                cell.contentBGView.layer.borderColor = theme.rightCellBorderColor.cgColor
                cell.contentBGView.layer.borderWidth = theme.rightCellBorderWidth
                cell.contentLabel.font = theme.rightCellContentFont
                cell.authorLabel.textColor = theme.rightCellAuthorTextColor
                cell.authorLabel.font = theme.rightCellAuthorFont
                cell.timeLabel.textColor = theme.rightCellTimeTextColor
                cell.timeLabel.font = theme.rightCellTimeFont
            
            } else {
                cell.contentLabel.textColor = theme.leftCellContentTextColor
                cell.contentBGView.backgroundColor = theme.leftCellContenBGColor
                cell.contentBGView.layer.borderColor = theme.leftCellBorderColor.cgColor
                cell.contentBGView.layer.borderWidth = theme.leftCellBorderWidth
                cell.contentLabel.font = theme.leftCellContentFont
                cell.authorLabel.textColor = theme.leftCellAuthorTextColor
                cell.authorLabel.font = theme.leftCellAuthorFont
                cell.timeLabel.textColor = theme.leftCellTimeTextColor
                cell.timeLabel.font = theme.leftCellTimeFont
                if prevMessage == nil || prevMessage!.author.id != message.author.id {
                    cell.avatarImageView.isHidden = false
                    cell.authorLabel.isHidden = false
                    
                } else {
                    cell.avatarImageView.isHidden = true
                    cell.authorLabel.isHidden = true
                }
            }
            
            cell.contentLabel.text = message.content
            cell.authorLabel.text = message.author.name
            cell.timeLabel.text = dateFormatter.string(from: message.date)
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
    }
}
