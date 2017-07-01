//
//  NavigationService.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/17.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import UIKit

struct NavigationService {

	var networkService = NetworkService()
	var searchStoryboard = UIStoryboard(name: "Search", bundle: nil)

	mutating func initWithSearchScreen(window: UIWindow) {
        let viewController: SearchViewController = controllerFactory(ViewModelType: SearchViewModel.self, PresenterType: SearchPresenter.self, storyboard: searchStoryboard)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
	}
    
    func controllerFactory<T: BaseViewController, V: BaseViewModel, P: BasePresenter>(ViewModelType: V.Type, PresenterType: P.Type, storyboard: UIStoryboard) -> T {
        
        var viewModel = ViewModelType.init()
        viewModel.navigationService = self
        
        var presenter = PresenterType.init()
        let viewController: T = storyboard.instantiateViewController()
        viewController.baseViewModel = viewModel
        viewController.basePresenter = presenter
        presenter.baseViewController = viewController
        
        return viewController
    }
    
}
