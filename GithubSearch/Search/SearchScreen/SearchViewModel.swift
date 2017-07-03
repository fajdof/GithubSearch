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
    
    var searchResults: [Repository]
    var id: String
    
    init(searchResults: [Repository], id: String) {
        self.searchResults = searchResults
        self.id = id
    }
}


extension SearchSectionModel: AnimatableSectionModelType {
    typealias Item = Repository
    typealias Identity = String
    
    var identity: String {
        return id
    }
    
    var items: [Repository] {
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
    
    func pushToSearchDetailScreen(navigationController: UINavigationController?, repository: Repository) {
        navigationService.pushToSearchDetailScreen(navigationController: navigationController, repository: repository)
    }

    func getSearchResults(withQuery query: String, sortedBy scope: String) {
        networkService.getSearchResults(withQuery: query, sortedBy: scope).map { [weak self] (response, data) -> Result<SearchResult> in
            guard let `self` = self else { return .failure(RequestError(message: "Error")) }
            
            return self.parseJSONAsTopLevelDictionary(data: data, response: response)
            
        }.subscribe(onNext: { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let data):
                let searchResultsModel = SearchSectionModel(searchResults: data.repositories, id: self.searchResultsId)
                self.searchResultsVariable.value = [searchResultsModel]
            case .failure(let error):
                self.errorVariable.value = error
            }
        }, onError: { [weak self] (error) in
            self?.errorVariable.value = error
        }, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
    }
    
    func sortDatasource(scope: SearchScope) {
        guard let repositories = searchResultsVariable.value.first?.items else {
            return
        }
        
        var sortedRepositories: [Repository] = repositories
        
        switch scope {
        case .Forks:
            sortedRepositories = repositories.sorted(by: { (firstRepos, secondRepos) -> Bool in
                return firstRepos.forksCount > secondRepos.forksCount
            })
        case .Stars:
            sortedRepositories = repositories.sorted(by: { (firstRepos, secondRepos) -> Bool in
                return firstRepos.starsCount > secondRepos.starsCount
            })
        case .Updated:
            sortedRepositories = repositories.sorted(by: { (firstRepos, secondRepos) -> Bool in
                guard let firstUpdatedAt = firstRepos.updatedAt, let secondUpdatedAt = secondRepos.updatedAt else { return true }
                return firstUpdatedAt.timeIntervalSince1970 > secondUpdatedAt.timeIntervalSince1970
            })
        }
        
        searchResultsVariable.value = [SearchSectionModel(searchResults: sortedRepositories, id: searchResultsId)]
    }

}
