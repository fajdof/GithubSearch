//
//  SearchViewModel.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/17.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import Alamofire
import ObjectMapper

struct SearchSectionModel {
    
    var searchResults: [SearchResult]
    var id: String
    
    init(searchResults: [SearchResult], id: String) {
        self.searchResults = searchResults
        self.id = id
    }
}


extension SearchSectionModel: AnimatableSectionModelType {
    typealias Item = SearchResult
    typealias Identity = String
    
    var identity: String {
        return id
    }
    
    var items: [SearchResult] {
        return searchResults
    }
    
    init(original: SearchSectionModel, items: [Item]) {
        self = SearchSectionModel(searchResults: items, id: original.id)
    }
}


class SearchViewModel: BaseViewModel, NetworkRequestHandler {

	var navigationService: NavigationService!
	var networkService: NetworkService!
    var searchResultsVariable = Variable<[SearchSectionModel]>([])
    var errorVariable = Variable<Error?>(nil)
    let bag = DisposeBag()
    let searchResultsId = "SearchResults"

	required init() {}

    func getSearchResults(withQuery query: String, sortedBy scope: String) {
        networkService.getSearchResults(withQuery: query, sortedBy: scope).map { [weak self] (response, data) -> Result<[SearchResult]> in
            guard let `self` = self else { return .failure(RequestError(message: "Error")) }
            
            return self.parseJSON(data: data, response: response)
            
        }.subscribe(onNext: { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let data):
                let searchResultsModel = SearchSectionModel(searchResults: data, id: self.searchResultsId)
                self.searchResultsVariable.value = [searchResultsModel]
            case .failure(let error):
                self.errorVariable.value = error
            }
        }, onError: { [weak self] (error) in
            self?.errorVariable.value = error
        }, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
    }

}
