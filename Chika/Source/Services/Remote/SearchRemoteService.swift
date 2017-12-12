//
//  SearchRemoteService.swift
//  Chika
//
//  Created by Mounir Ybanez on 12/12/17.
//  Copyright © 2017 Nir. All rights reserved.
//

protocol SearchRemoteService: class {

    func searchPeople(withKeyword keyword: String, callback: @escaping (ServiceResult<[PersonSearchObject]>) -> Void)
}

class SearchRemoteServiceProvider: SearchRemoteService {
    
    var personSearch: PersonRemoteSearch
    
    init(personSearch: PersonRemoteSearch = PersonRemoteSearchProvider()) {
        self.personSearch = personSearch
    }
    
    func searchPeople(withKeyword keyword: String, callback: @escaping (ServiceResult<[PersonSearchObject]>) -> Void) {
        personSearch.search(withKeyword: keyword) { object in
            guard !object.isEmpty else {
                callback(.err(ServiceError("no persons found")))
                return
            }
            
            callback(.ok(object))
        }
    }
}
