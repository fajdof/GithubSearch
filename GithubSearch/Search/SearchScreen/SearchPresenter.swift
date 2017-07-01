//
//  SearchPresenter.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/17.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import UIKit


class SearchPresenter: BasePresenter {

	private struct SearchStatic {
		static var title: String { get { return "Title" } }
	}

	weak var baseViewController: BaseViewController!
	weak var viewController: SearchViewController! {
		return baseViewController as! SearchViewController
	}

	required init() {}


}