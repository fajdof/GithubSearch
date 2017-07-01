//
//  UITableView+Dequeue.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
    static var nibName: String {
        return String(describing: self)
    }
}

extension UITableView {
    func registerForReuse<T: UITableViewCell>(_ cellClassType: T.Type) {
        self.register(cellClassType, forCellReuseIdentifier: cellClassType.defaultReuseIdentifier)
    }
    
    func registerWithNib<T: UITableViewCell>(_ cellClassType: T.Type) {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
}
