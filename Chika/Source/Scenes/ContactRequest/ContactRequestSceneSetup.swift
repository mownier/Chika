//
//  ContactRequestSceneSetup.swift
//  Chika
//
//  Created Mounir Ybanez on 12/9/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactRequestSceneSetup: class {

    func formatTitle(in navigationItem: UINavigationItem) -> Bool
    func format(cell: UITableViewCell, theme: ContactRequestSceneTheme, item: ContactRequestSceneItem?, action: ContactRequestSceneCellAction?) -> Bool
    func height(for cell: UITableViewCell?, theme: ContactRequestSceneTheme, item: ContactRequestSceneItem?, action: ContactRequestSceneCellAction?) -> CGFloat
    func headerHeight(withTitle title: String?) -> CGFloat
    func swipeActionsConfig(for item: ContactRequestSceneItem?, category: ContactRequestSceneItem.SectionCategory, revoke: @escaping () -> Void, ignore: @escaping () -> Void, accept: @escaping () -> Void, showMessage: @escaping () -> Void) -> UISwipeActionsConfiguration?
}

extension ContactRequestScene {
    
    class Setup: ContactRequestSceneSetup {
        
        weak var theme: ContactRequestSceneTheme!
        var imageCreator: AppImageCreator
        
        init(imageCreator: AppImageCreator = ImageCreator()) {
            self.imageCreator = imageCreator
        }
        
        func formatTitle(in navigationItem: UINavigationItem) -> Bool {            
            navigationItem.title = "Contact Requests"
            return true
        }
        
        func format(cell: UITableViewCell, theme: ContactRequestSceneTheme, item: ContactRequestSceneItem?, action: ContactRequestSceneCellAction?) -> Bool {
            guard let cell = cell as? ContactRequestSceneCell, let item = item else {
                return false
            }
            
            cell.nameLabel.font = theme.nameFont
            cell.messageLabel.font = theme.messageFont
            cell.statusLabel.font = theme.statusFont
            cell.action = action
            cell.nameLabel.text = item.request.requestee.displayName
            cell.messageLabel.text = item.requestMessage
            cell.statusLabel.text = item.statusText
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return true
        }
        
        func height(for cell: UITableViewCell?, theme: ContactRequestSceneTheme, item: ContactRequestSceneItem?, action: ContactRequestSceneCellAction?) -> CGFloat {
            guard let cell = cell as? ContactRequestSceneCell, format(cell: cell, theme: theme, item: item, action: action) else {
                return 0
            }
            
            return max(cell.avatar.frame.maxX, cell.statusLabel.frame.maxY) + cell.avatar.frame.minY
        }
        
        func headerHeight(withTitle title: String?) -> CGFloat {
            guard title != nil else {
                return 0
            }
            
            return 44
        }
        
        func swipeActionsConfig(for item: ContactRequestSceneItem?, category: ContactRequestSceneItem.SectionCategory, revoke: @escaping () -> Void, ignore: @escaping () -> Void, accept: @escaping () -> Void, showMessage: @escaping () -> Void) -> UISwipeActionsConfiguration? {
            guard let item = item else {
                return nil
            }
            
            var actions: [UIContextualAction] = []
            
            switch category {
            case .sent:
                let action = revokeAction(withItem: item, block: revoke)
                actions.append(action)
                
            case .pending:
                var action = ignoreAction(withItem: item, block: ignore)
                if action != nil {
                    actions.append(action!)
                }
                action = acceptAction(withItem: item, block: accept)
                if action != nil {
                    actions.append(action!)
                }
            
            case .none:
                return nil
            }
                
            if !item.request.message.isEmpty {
                let action = showMessageAction(withItem: item, block: showMessage)
                actions.append(action)
            }
            
            guard !actions.isEmpty else {
                return nil
            }
            
            let config = UISwipeActionsConfiguration(actions: actions)
            config.performsFirstActionWithFullSwipe = false
            
            return config
        }
    }
}

fileprivate extension ContactRequestScene.Setup {
    
    func revokeAction(withItem item: ContactRequestSceneItem, block: @escaping () -> Void) -> UIContextualAction {
        let revoke = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            switch item.action.revoke {
            case .none, .retry: block()
            default: break
            }
            completion(true)
        }
        
        revoke.backgroundColor = theme.actionDestructiveColor
        
        switch item.action.revoke {
        case .none:       revoke.image = revokeImage
        case .ok:         revoke.image = revokedImage
        case .requesting: revoke.image = revokingImage
        case .retry:      revoke.image = retryImage
        }
        
        return revoke
    }
    
    func ignoreAction(withItem item: ContactRequestSceneItem, block: @escaping () -> Void) -> UIContextualAction? {
        switch item.action.accept {
        case .none, .retry:
            let ignore = UIContextualAction(style: .normal, title: nil) { _, _, completion in
                switch item.action.ignore {
                case .none, .retry: block()
                default: break
                }
                completion(true)
            }
            
            ignore.backgroundColor = theme.actionDestructiveColor
            
            switch item.action.ignore {
            case .none:       ignore.image = ignoreImage
            case .ok:         ignore.image = ignoredImage
            case .requesting: ignore.image = ignoringImage
            case .retry:      ignore.image = retryImage
            }
        
            return ignore
            
        default:
            return nil
        }
    }
    
    func acceptAction(withItem item: ContactRequestSceneItem, block: @escaping () -> Void) -> UIContextualAction? {
        switch item.action.ignore {
        case .none, .retry:
            let accept = UIContextualAction(style: .normal, title: nil) { _, _, completion in
                switch item.action.accept {
                case .none, .retry: block()
                default: break
                }
                completion(true)
            }
            
            accept.backgroundColor = theme.actionOKColor
            
            switch item.action.accept {
            case .none:       accept.image = acceptImage
            case .ok:         accept.image = acceptedImage
            case .requesting: accept.image = acceptingImage
            case .retry:      accept.image = retryImage
            }
            
            return accept
            
        default:
            return nil
        }
    }
    
    func showMessageAction(withItem item: ContactRequestSceneItem, block: @escaping () -> Void) -> UIContextualAction {
        let showMessage = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            block()
            completion(true)
        }
        showMessage.backgroundColor = theme.actionShowMessageColor
        showMessage.image = item.isMessageShown ? hideMessageImage : showMessageImage
        return showMessage
    }
    
    private var showMessageImage: UIImage? {
        return image(for: "Show\nMessage")
    }
    
    private var hideMessageImage: UIImage? {
        return image(for: "Hide\nMessage")
    }
    
    private var acceptImage: UIImage? {
        return image(for: "Accept")
    }
    
    private var acceptingImage: UIImage? {
        return image(for: "Accepting")
    }
    
    private var acceptedImage: UIImage? {
        return image(for: "Accepted")
    }
    
    private var ignoreImage: UIImage? {
        return image(for: "Ignore")
    }
    
    private var ignoringImage: UIImage? {
        return image(for: "Ignoring")
    }
    
    private var ignoredImage: UIImage? {
        return image(for: "Ignored")
    }
    
    private var revokeImage: UIImage? {
        return image(for: "Revoke")
    }
    
    private var revokingImage: UIImage? {
        return image(for: "Revoking")
    }
    
    private var revokedImage: UIImage? {
        return image(for: "Revoked")
    }
    
    private var retryImage: UIImage? {
        return image(for: "Retry")
    }
    
    private func image(for text: String) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.bounds = frame
        label.font = theme.actionFont
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.backgroundColor = .clear
        label.text = text
        return imageCreator.create(for: label)
    }
}
