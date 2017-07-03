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
        
        bindDataSource()
        
        setupRx()
	}
    
    func setupRx() {
        searchBar.rx.selectedScopeButtonIndex.asDriver().drive(onNext: { [weak self] (index) in
            guard let searchScope = SearchScope(rawValue: index) else { return }
            self?.searchScope = searchScope
        }, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
        
        searchBar.rx.cancelButtonClicked.asDriver().drive(onNext: { [weak self] in
            self?.searchBar.resignFirstResponder()
        }, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
        
        searchBar.rx.searchButtonClicked.asDriver().drive(onNext: { [weak self] in
            guard let searchText = self?.searchBar.text else { return }
            self?.searchGithub(withText: searchText)
        }, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard let `self` = self else { return }
            
            self.tableView.deselectRow(at: indexPath, animated: true)
            let item = self.dataSource[indexPath]
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
        
        viewModel.searchResultsVariable.asObservable().subscribe(onNext: { (_) in
            SVProgressHUD.dismiss()
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
        
        viewModel.errorVariable.asObservable().subscribe(onNext: { (err) in
            if let error = err {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
    }
    
    func bindDataSource() {
        registerNibs()
        dataSource = RxTableViewSectionedAnimatedDataSource<SearchSectionModel>()
        
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
            
            return cell
        }
        
    }
    
    func searchGithub(withText searchText: String) {
        SVProgressHUD.show()
        
        viewModel.getSearchResults(withQuery: searchText, sortedBy: searchScope.parameterDescription)
    }

}
