//
//  ContactsSceneAddPopover.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/5/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactsSceneAddPopoverDelegate: class {
    
    func addPopoverDidOK(message: String, person: Person)
    func addPopoverDidCancel()
}

@objc protocol ContactsSceneAddPopoverInteraction: class {
    
    func didTapDone()
    func didTapCancel()
}

class ContactsSceneAddPopover: UIViewController {
    
    weak var delegate: ContactsSceneAddPopoverDelegate?
    
    var input: UITextView!
    var doneButton: UIButton!
    var cancelButton: UIButton!
    var titleLabel: UILabel!
    var characterLimitLabel: UILabel!
    
    var person: Person
    var theme: ContactsSceneAddPopoverTheme
    var initialText: String
    var characterLimit: UInt = 100
    
    init(theme: ContactsSceneAddPopoverTheme, person: Person) {
        self.theme = theme
        self.person = person
        var personName  = "!"
        if !person.name.isEmpty {
            personName = " \(person.name)!"
        }
        self.initialText = String(format: "Hi%@ I would like to add you as my contact.", personName)
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(person: Person) {
        let theme = Theme()
        self.init(theme: theme, person: person)
        self.modalPresentationStyle = .popover
        self.preferredContentSize = CGSize(width: 280, height: 160)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(person: Person())
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = theme.bgColor
        
        titleLabel = UILabel()
        titleLabel.text = "Message"
        titleLabel.textColor = theme.titleTextColor
        titleLabel.font = theme.titleFont
        titleLabel.textAlignment = .center
        
        doneButton = UIButton()
        doneButton.setTitle("DONE", for: .normal)
        doneButton.setTitleColor(theme.buttonTextColor, for: .normal)
        doneButton.titleLabel?.font = theme.buttonFont
        doneButton.tintColor = theme.buttonTextColor
        doneButton.addTarget(self, action: #selector(self.didTapDone), for: .touchUpInside)
        doneButton.contentHorizontalAlignment = .right
        
        cancelButton = UIButton()
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(theme.buttonTextColor, for: .normal)
        cancelButton.titleLabel?.font = theme.buttonFont
        cancelButton.tintColor = theme.buttonTextColor
        cancelButton.addTarget(self, action: #selector(self.didTapCancel), for: .touchUpInside)
        cancelButton.contentHorizontalAlignment = .left
        
        input = UITextView()
        input.textColor = theme.inputTextColor
        input.font = theme.inputFont
        input.tintColor = theme.inputTextColor
        input.layer.cornerRadius = 5
        input.layer.masksToBounds = true
        input.backgroundColor = theme.inputBGColor
        input.delegate = self
        
        characterLimitLabel = UILabel()
        characterLimitLabel.textColor = theme.inputTextColor
        characterLimitLabel.font = theme.inputFont
        characterLimitLabel.textAlignment = .right
        
        view.addSubview(input)
        view.addSubview(doneButton)
        view.addSubview(cancelButton)
        view.addSubview(titleLabel)
        view.addSubview(characterLimitLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        input.text = initialText
        textViewDidChange(input)
        popoverPresentationController?.backgroundColor = theme.bgColor
        popoverPresentationController?.permittedArrowDirections = .any
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        input.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        input.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        let spacing: CGFloat = 8
        var rect = CGRect.zero
        
        rect.origin.x = spacing
        rect.size.width = 64
        rect.size.height = 40
        cancelButton.frame = rect
        
        rect.origin.x = view.bounds.width - rect.width - spacing
        doneButton.frame = rect
        
        rect.origin.x = cancelButton.frame.maxX + spacing
        rect.size.width = view.bounds.width - rect.origin.x - spacing * 2 - doneButton.frame.width
        titleLabel.frame = rect
        
        rect.origin.x = spacing * 2
        rect.size.height = 32
        rect.size.width = view.bounds.width - spacing * 4
        rect.origin.y = view.bounds.height - rect.height
        characterLimitLabel.frame = rect
        
        rect.origin.y = titleLabel.frame.maxY + spacing
        rect.size.height = view.bounds.height - rect.origin.y - characterLimitLabel.frame.height
        input.frame = rect
    }
}

extension ContactsSceneAddPopover: ContactsSceneAddPopoverInteraction {
    
    func didTapDone() {
        delegate?.addPopoverDidOK(message: input.text, person: person)
        dismiss(animated: true, completion: nil)
    }
    
    func didTapCancel() {
        delegate?.addPopoverDidCancel()
        dismiss(animated: true, completion: nil)
    }
}

extension ContactsSceneAddPopover: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.characters.count + (text.characters.count - range.length) <= characterLimit
    }
    
    func textViewDidChange(_ textView: UITextView) {
        characterLimitLabel.text = "\(textView.text.characters.count) / \(characterLimit)"
    }
}
