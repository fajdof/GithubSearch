//
//  UIVIewController+ErrorShowing.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 03/07/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController {
    func showErrorMessage(error: Error?) {
        guard let err = error else { return }
        
        if let message = (err as? RequestError)?.message {
            SVProgressHUD.showError(withStatus: message)
        } else {
            SVProgressHUD.showError(withStatus: err.localizedDescription)
        }
    }
}
