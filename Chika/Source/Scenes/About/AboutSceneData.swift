//
//  AboutSceneData.swift
//  Chika
//
//  Created Mounir Ybanez on 12/14/17.
//  Copyright © 2017 Nir. All rights reserved.
//

import Foundation

protocol AboutSceneData: class {

    var itemCount: Int { get }
    
    func item(at row: Int) -> AboutSceneItem?
}

extension AboutScene {
    
    class Data: AboutSceneData {
    
        var items: [AboutSceneItem]
        var itemCount: Int {
            return items.count
        }
    
        init(bundle: Bundle = Bundle.main) {
            self.items = []
            
            guard let info = bundle.infoDictionary else {
                return
            }
            
            var appName = info["CFBundleDisplayName"] as? String
            appName = (appName == nil || appName!.isEmpty) ? info["CFBundleName"] as? String : appName
            if let name = appName, !name.isEmpty {
                var item = AboutSceneItem()
                item.label = "App Name"
                item.content = name
                self.items.append(item)
            }
            
            if let version = info["CFBundleShortVersionString"] as? String {
                var item = AboutSceneItem()
                item.label = "Version"
                item.content = version
                self.items.append(item)
            }
            
            if let build = info["CFBundleVersion"] as? String {
                var item = AboutSceneItem()
                item.label = "Build"
                item.content = build
                self.items.append(item)
            }
        }
    
        func item(at row: Int) -> AboutSceneItem? {
            guard row >= 0, row < items.count else { return nil }
            return items[row]
        }
    }
}
