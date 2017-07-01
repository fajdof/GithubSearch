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
		static var title: String { get { return "Title" } }
	}

	weak var baseViewController: BaseViewController!
	weak var viewController: SearchDetailViewController! {
		return baseViewController as! SearchDetailViewController
	}

	required init() {}


}