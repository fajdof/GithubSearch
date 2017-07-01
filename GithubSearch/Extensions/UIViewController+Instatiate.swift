//
//  UIViewController+Instatiate.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>() -> T {
        let optViewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier)
        
        guard let viewController = optViewController as? T else {
            fatalError("Couldn’t instantiate view controller with identifier \(T.storyboardIdentifier)")
        }
        
        return viewController
    }
}
