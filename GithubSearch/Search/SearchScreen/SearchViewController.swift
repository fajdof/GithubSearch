//
//  SearchViewController.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/17.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import RxDataSources

enum SearchScope: Int {
    case Stars = 0
    case Forks = 1
    case Updated = 2
    
    var parameterDescription: String {
        switch self {
        case .Stars:
            return "stars"
        case .Forks:
            return "forks"
        case .Updated:
            return "updated"
        }
    }
}

class SearchViewController: BaseViewController {

	var viewModel: SearchViewModel! {
		return baseViewModel as! SearchViewModel
	}
	var presenter: SearchPresenter! {
		return basePresenter as! SearchPresenter
	}
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let bag = DisposeBag()
    var searchScope = SearchScope.Stars
    var dataSource: RxTableViewSectionedAnimatedDataSource<SearchSectionModel>!

	override func viewDidLoad() {
		super.viewDidLoad()
        
        presenter.setup()
        
        bindDataSource()
        
        setupRx()
	}
    
    func setupRx() {
        searchBar.rx.selectedScopeButtonIndex.asDriver().drive(onNext: { [weak self] (index) in
            guard let searchScope = SearchScope(rawValue: index) else { return }
            self?.searchScope = searchScope
            self?.viewModel.sortDatasource(scope: searchScope)
        }, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
        
        searchBar.rx.cancelButtonClicked.asDriver().drive(onNext: { [weak self] in
            self?.searchBar.resignFirstResponder()
        }, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
        
        searchBar.rx.searchButtonClicked.asDriver().drive(onNext: { [weak self] in
            guard let searchText = self?.searchBar.text else { return }
            self?.searchBar.resignFirstResponder()
            self?.searchGithub(withText: searchText)
        }, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard let `self` = self else { return }
            
            self.tableView.deselectRow(at: indexPath, animated: true)
            let repository = self.dataSource[indexPath]
            self.viewModel.pushToSearchDetailScreen(navigationController: self.navigationController, repository: repository)
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
        
        viewModel.searchResultsVariable.asObservable().subscribe(onNext: { (sectionModels) in
            SVProgressHUD.dismiss()
            if sectionModels.first?.items.count == 0 {
                SVProgressHUD.showError(withStatus: "No results")
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
        
        viewModel.errorVariable.asObservable().subscribe(onNext: { [weak self] (error) in
            self?.showErrorMessage(error: error)
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
    }
    
    func bindDataSource() {
        registerNibs()
        dataSource = RxTableViewSectionedAnimatedDataSource<SearchSectionModel>()
        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)
        
        configureDataSource()
        viewModel.searchResultsVariable.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).addDisposableTo(bag)
    }
    
    func registerNibs() {
        tableView.registerWithNib(SearchResultCell.self)
    }
    
    func configureDataSource() {
        dataSource.configureCell = { [weak self] (dataSrc, tv, idxPath, item) in
            guard let `self` = self else { return UITableViewCell() }
            
            let cell: SearchResultCell = tv.dequeueReusableCell()
            self.presenter.configureSearchResultCell(cell: cell, repository: item)
            
            return cell
        }
        
    }
    
    func searchGithub(withText searchText: String) {
        SVProgressHUD.show()
        
        viewModel.getSearchResults(withQuery: searchText, sortedBy: searchScope.parameterDescription)
    }

}
