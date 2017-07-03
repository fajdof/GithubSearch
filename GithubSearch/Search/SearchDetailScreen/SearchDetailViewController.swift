//
//  SearchDetailViewController.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/17.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources
import SVProgressHUD


class SearchDetailViewController: BaseViewController {

	var viewModel: SearchDetailViewModel! {
		return baseViewModel as! SearchDetailViewModel
	}
	var presenter: SearchDetailPresenter! {
		return basePresenter as! SearchDetailPresenter
	}
    @IBOutlet weak var tableView: UITableView!
    
    var repository: Repository!
    let bag = DisposeBag()
    var dataSource: RxTableViewSectionedReloadDataSource<SearchDetailSectionModel>!

	override func viewDidLoad() {
		super.viewDidLoad()
        
        presenter.setup()
        
        bindDataSource()
        
        setupRx()
        
        refreshRepositoryDetails()
	}
    
    func setupRx() {
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard let `self` = self else { return }
            
            self.tableView.deselectRow(at: indexPath, animated: true)
            if let url = self.dataSource[indexPath] as? URL {
                UIApplication.shared.openURL(url)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
        
        viewModel.errorVariable.asObservable().subscribe(onNext: { (error) in
            dump(error)
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(bag)
    }
    
    func bindDataSource() {
        registerNibs()
        dataSource = RxTableViewSectionedReloadDataSource<SearchDetailSectionModel>()
        
        viewModel.setSearchDetailVariable(repository: repository)
        
        configureDataSource()
        viewModel.searchDetailVariable.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).addDisposableTo(bag)
    }
    
    func registerNibs() {
        tableView.registerWithNib(SearchResultCell.self)
        tableView.registerWithNib(OtherInfoCell.self)
        tableView.registerWithNib(OpenLinkCell.self)
    }
    
    func configureDataSource() {
        dataSource.configureCell = { [weak self] (dataSrc, tv, idxPath, item) in
            guard let `self` = self else { return UITableViewCell() }
            
            switch dataSrc[idxPath.section] {
            case .GeneralSection(let repositories):
                let cell: SearchResultCell = tv.dequeueReusableCell()
                self.presenter.configureSearchResultCell(cell: cell, repository: repositories[idxPath.row])
                return cell
            case .OpenLinkSection(_):
                let cell: OpenLinkCell = tv.dequeueReusableCell()
                self.presenter.configureOpenLinkCell(cell: cell)
                return cell
            case .OtherInfoSection(let repositories):
                let cell: OtherInfoCell = tv.dequeueReusableCell()
                self.presenter.configureOtherInfoCell(cell: cell, repository: repositories[idxPath.row])
                return cell
            }
        }
        
    }
    
    func refreshRepositoryDetails() {
        viewModel.getRepositoryDetails(withRepositoryId: repository.id.description)
    }


}
