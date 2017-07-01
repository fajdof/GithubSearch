//
//  BasePresenter.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/17.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

protocol BasePresenter {

	init()

	weak var baseViewController: BaseViewController! { get set }
}
