//
//  ContactsSceneIndexView.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/7/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

protocol ContactsSceneIndexViewDelegate: class {
    
    func indexViewDidSelectIndex(_ char: Character)
}

class ContactsSceneIndexView: UIView, UITableViewDataSource, UITableViewDelegate {

    class Cell: UITableViewCell {
        
        var characterLabel: UILabel!
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            initSetup()
        }
        
        convenience required init?(coder aDecoder: NSCoder) {
            self.init(style: .default, reuseIdentifier: "Cell")
        }
        
        func initSetup() {
            selectionStyle = .none
            characterLabel = UILabel()
            characterLabel.textAlignment = .center
            addSubview(characterLabel)
        }
        
        override func layoutSubviews() {
            characterLabel.frame = bounds
        }
    }
    
    weak var delegate: ContactsSceneIndexViewDelegate?
    
    var tableView: UITableView!
    var indexBGView: UIView!
    var indexFont: UIFont?
    var indexTextColor: UIColor = .black
    var indexBGColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
        didSet {
            guard indexBGView != nil else {
                return
            }
            
            indexBGView.backgroundColor = indexBGColor
        }
    }
    var indexChars: [Character] = [] {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
        initSetup()
    }
    
    func initSetup() {
        tableView = UITableView()
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = 14
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .clear
        
        indexBGView = UIView()
        indexBGView.layer.masksToBounds = true
        indexBGView.backgroundColor = indexBGColor
        
        addSubview(indexBGView)
        addSubview(tableView)
    }
    
    override func layoutSubviews() {
        let spacing: CGFloat = 8
        var rect = CGRect.zero
        
        tableView.reloadData()
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        
        rect.size.width = frame.width
        rect.size.height = min(frame.height, tableView.contentSize.height)
        rect.origin.y = (frame.height - rect.height) / 2
        tableView.frame = rect
        
        rect.size.height += (spacing * 2)
        rect.origin.y -= spacing
        indexBGView.frame = rect
        indexBGView.layer.cornerRadius = rect.width / 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indexChars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: Cell! = tableView.dequeueReusableCell(withIdentifier: "Cell") as? Cell
        if cell == nil {
            cell = Cell(style: .default, reuseIdentifier: "Cell")
            cell.characterLabel.textColor = indexTextColor
            cell.characterLabel.font = indexFont
            cell.backgroundColor = .clear
        }
        cell.characterLabel.text = String(indexChars[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.indexViewDidSelectIndex(indexChars[indexPath.row])
    }
}
