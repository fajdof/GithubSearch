//
//  SearchPresenter.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/17.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


class SearchPresenter: BasePresenter {

	private struct SearchStatic {
		static var title: String { get { return "Search Repositories" } }
        static var name: String { get { return "Repository name: " } }
        static var ownerName: String { get { return "Owner: " } }
        static var watchers: String { get { return "Watchers: " } }
        static var forks: String { get { return "Forks: " } }
        static var issues: String { get { return "Issues: " } }
        static var stars: String { get { return "Stars: " } }
        static var updated: String { get { return "Last updated: " } }
	}

	weak var baseViewController: BaseViewController!
	weak var viewController: SearchViewController! {
		return baseViewController as! SearchViewController
	}

	required init() {}

    func setup() {
        viewController.title = SearchStatic.title
        
        viewController.tableView.rowHeight = UITableViewAutomaticDimension
        viewController.tableView.estimatedRowHeight = 150
        viewController.tableView.tableFooterView = UIView()
    }
    
    func configureSearchResultCell(cell: SearchResultCell, repository: Repository) {
        cell.forksCountLabel.text = SearchStatic.forks + repository.forksCount.description
        cell.watchersCountLabel.text = SearchStatic.watchers + repository.watchersCount.description
        cell.issuesCountLabel.text = SearchStatic.issues + repository.issuesCount.description
        cell.starsCountLabel.text = SearchStatic.stars + repository.starsCount.description
        
        cell.nameLabel.text = SearchStatic.name + (repository.name ?? "--")
        cell.ownerNameLabel.text = SearchStatic.ownerName + (repository.owner?.name ?? "--")
        cell.updatedAtLabel.text = SearchStatic.updated + (repository.updatedAtDescription ?? "--")
        if let url = repository.owner?.avatarUrl {
            cell.avatarImageView.kf.setImage(with: URL(string: url))
        }
    }
}
