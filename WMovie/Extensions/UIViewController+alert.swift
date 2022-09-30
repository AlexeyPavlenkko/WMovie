//
//  UIViewController+alert.swift
//  WMovie
//
//  Created by Алексей Павленко on 30.09.2022.
//

import UIKit

extension UIViewController {
    func showAlert(title: String? = nil, message: String, dismissAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: dismissAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}

