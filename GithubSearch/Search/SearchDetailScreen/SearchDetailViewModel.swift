//
//  SearchDetailViewModel.swift
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

enum SearchDetailSectionModel {
    case GeneralSection(repositories: Array<Repository>)
    case OpenLinkSection(links: Array<URL>)
    case OtherInfoSection(otherInfos: Array<Repository>)
}


extension SearchDetailSectionModel: SectionModelType {
    typealias Item = Any
    
    var items: [Item] {
        switch  self {
        case .GeneralSection(let repositories):
            return repositories
        case .OpenLinkSection(let links):
            return links
        case .OtherInfoSection(let otherInfos):
            return otherInfos
        }
    }
    
    init(original: SearchDetailSectionModel, items: [Item]) {
        self = original
    }
}


class SearchDetailViewModel: BaseViewModel, NetworkRequestHandler {

	var navigationService: NavigationService!
	var networkService: NetworkService!
    var searchDetailVariable = Variable<[SearchDetailSectionModel]>([])
    var errorVariable = Variable<Error?>(nil)
    let bag = DisposeBag()

	required init() {}

    func getRepositoryDetails(withRepositoryId repositoryId: String) {
        networkService.getRepositoryDetails(withRepositoryId: repositoryId).map { [weak self] (response, data) -> Result<Repository> in
            guard let `self` = self else { return .failure(RequestError(message: "Error")) }
            
            return self.parseJSONAsTopLevelDictionary(data: data, response: response)
            
            }.subscribe(onNext: { [weak self] (result) in
                guard let `self` = self else { return }
                
                switch result {
                case .success(let data):
                    self.setSearchDetailVariable(repository: data)
                case .failure(let error):
                    self.errorVariable.value = error
                }
            }, onError: { [weak self] (error) in
                    self?.errorVariable.value = error
            }, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
    }
    
    func setSearchDetailVariable(repository: Repository) {
        var searchDetailSectionModels: [SearchDetailSectionModel] = []
        
        let generalSection = SearchDetailSectionModel.GeneralSection(repositories: [repository])
        searchDetailSectionModels.append(generalSection)
        if let urlString = repository.repositoryUrl, let url = URL(string: urlString) {
            let linksSection = SearchDetailSectionModel.OpenLinkSection(links: [url])
            searchDetailSectionModels.append(linksSection)
        }
        let otherInfoSection = SearchDetailSectionModel.OtherInfoSection(otherInfos: [repository])
        searchDetailSectionModels.append(otherInfoSection)
        
        searchDetailVariable.value = searchDetailSectionModels
    }

}
