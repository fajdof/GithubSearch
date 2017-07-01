//
//  SearchViewController.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/17.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import UIKit


class SearchViewController: BaseViewController {

	var viewModel: SearchViewModel! {
		return baseViewModel as! SearchViewModel
	}
	var presenter: SearchPresenter! {
		return basePresenter as! SearchPresenter
	}
    
    @IBOutlet weak var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

}
