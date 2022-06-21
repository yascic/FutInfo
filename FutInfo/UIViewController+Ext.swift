//
//  UIViewController+Ext.swift
//  FutInfo
//
//  Created by Yahya Aščić on 16.05.22.
//

import UIKit

extension UIViewController {
    func alertUser(withTitle title: String, withMessage message: String, dismissText: String, onCompletion completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: dismissText, style: .default, handler: { action in
                if let completion = completion { completion() }
            })
            alert.addAction(ok)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }
    }
}
