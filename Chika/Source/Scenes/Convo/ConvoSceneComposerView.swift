//
//  ConvoSceneComposerView.swift
//  Chika
//
//  Created by Mounir Ybanez on 11/25/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

@objc protocol ConvoSceneComposerViewInteraction: class {
    
    func contentDidChangeText(notif: NSNotification)
    func didTapPlaceholder()
}

class ConvoSceneComposerView: UIView {
    
    var strip: UIView!
    var sendButton: UIButton!
    var contentInput: UITextView!
    var placeholderLabel: UILabel!
    var isKeyboardShown: Bool = false
    
    var notifCenter: NotificationCenter = NotificationCenter.default
    
    deinit {
        removeContentObserver()
    }
    
    convenience init() {
        self.init(frame: .zero)
        initSetup()
    }
    
    func initSetup() {
        strip = UIView()
        
        sendButton = UIButton()
        sendButton.setTitle("Send", for: .normal)
        
        contentInput = UITextView()
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Write message"
        placeholderLabel.isUserInteractionEnabled = true
        
        addPlaceholderTap()
        addContentObserver()
        
        addSubview(strip)
        addSubview(sendButton)
        addSubview(contentInput)
        addSubview(placeholderLabel)
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        let spacing: CGFloat = 8
        
        rect.size.width = bounds.width
        rect.size.height = 1
        strip.frame = rect
        
        rect.size.width = 44
        rect.size.height = rect.width
        rect.origin.x = bounds.width - rect.width - spacing
        if !isKeyboardShown {
            rect.origin.y = (bounds.height - rect.height - safeAreaInsets.bottom) / 2
        } else {
            rect.origin.y = sendButton.frame.origin.y
        }
        sendButton.frame = rect
        
        rect.origin.y = spacing
        rect.origin.x = spacing
        rect.size.width = bounds.width - sendButton.frame.width - spacing * 2
        if !isKeyboardShown {
            rect.size.height = bounds.height - spacing * 2 - safeAreaInsets.bottom
        } else {
            rect.size.height = contentInput.frame.height
        }
        contentInput.frame = rect
        
        rect.size = placeholderLabel.sizeThatFits(rect.size)
        rect.origin.x += contentInput.textContainerInset.left
        rect.origin.x += contentInput.textContainer.lineFragmentPadding
        rect.origin.y += contentInput.textContainerInset.top
        placeholderLabel.frame = rect
    }
    
    func updateContent(_ content: String) {
        contentInput.text = content
        notifCenter.post(
            name: NSNotification.Name.UITextViewTextDidChange,
            object: contentInput)
    }
    
    func addContentObserver() {
        notifCenter.addObserver(
            self,
            selector: #selector(self.contentDidChangeText),
            name: NSNotification.Name.UITextViewTextDidChange,
            object: nil)
    }
    
    func removeContentObserver() {
        notifCenter.removeObserver(
            self,
            name: NSNotification.Name.UITextViewTextDidChange,
            object: nil)
    }
    
    func addPlaceholderTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapPlaceholder))
        tap.numberOfTapsRequired = 1
        placeholderLabel.addGestureRecognizer(tap)
    }
}

extension ConvoSceneComposerView: ConvoSceneComposerViewInteraction {
    
    func contentDidChangeText(notif: NSNotification) {
        guard let textView = notif.object as? UITextView,
            textView == contentInput, contentInput.isFirstResponder else {
                return
        }
        
        placeholderLabel.isHidden = !contentInput.text.isEmpty
    }
    
    func didTapPlaceholder() {
        if !contentInput.isFirstResponder {
            contentInput.becomeFirstResponder()
        }
    }
}
