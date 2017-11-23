//
//  TableViewMock.swift
//  ChikaTests
//
//  Created by Mounir Ybanez on 11/23/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class TableViewMock: UITableView {

    var isReloadDataCalled: Bool = false
    
    override func reloadData() {
        isReloadDataCalled = true
    }
}
