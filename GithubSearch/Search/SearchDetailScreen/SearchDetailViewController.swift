//
//  SearchDetailViewController.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/17.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import UIKit


class SearchDetailViewController: BaseViewController {

	var viewModel: SearchDetailViewModel! {
		return baseViewModel as! SearchDetailViewModel
	}
	var presenter: SearchDetailPresenter! {
		return basePresenter as! SearchDetailPresenter
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

}