//
//  BaseViewModel.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/17.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

protocol BaseViewModel {
	var navigationService: NavigationService! { get set }

	init()
}
