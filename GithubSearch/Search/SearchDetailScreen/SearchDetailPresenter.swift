//
//  SearchDetailPresenter.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/17.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import UIKit


class SearchDetailPresenter: BasePresenter {

	private struct SearchDetailStatic {
		static var title: String { get { return "Repository" } }
        static var branch: String { get { return "Default branch: " } }
        static var language: String { get { return "Language: " } }
        static var wiki: String { get { return "This repository has a Wiki" } }
        static var noWiki: String { get { return "This repository has no Wiki" } }
        static var openLink: String { get { return "Open Link" } }
	}

	weak var baseViewController: BaseViewController!
	weak var viewController: SearchDetailViewController! {
		return baseViewController as! SearchDetailViewController
	}
    let searchPresenter = SearchPresenter()

	required init() {}

    func setup() {
        viewController.title = SearchDetailStatic.title
        
        viewController.tableView.rowHeight = UITableViewAutomaticDimension
        viewController.tableView.estimatedRowHeight = 150
        viewController.tableView.tableFooterView = UIView()
    }
    
    func configureSearchResultCell(cell: SearchResultCell, repository: Repository) {
        searchPresenter.configureSearchResultCell(cell: cell, repository: repository)
        cell.selectionStyle = .none
    }
    
    func configureOtherInfoCell(cell: OtherInfoCell, repository: Repository) {
        cell.defaultBranchLabel.text = SearchDetailStatic.branch + (repository.defaultBranch ?? "--")
        cell.languageLabel.text = SearchDetailStatic.language + (repository.language ?? "--")
        if repository.hasWiki {
            cell.hasIssuesLabel.text = SearchDetailStatic.wiki
        } else {
            cell.hasIssuesLabel.text = SearchDetailStatic.noWiki
        }
        cell.selectionStyle = .none
    }
    
    func configureOpenLinkCell(cell: OpenLinkCell) {
        cell.openLinkLabel.text = SearchDetailStatic.openLink
    }

}
