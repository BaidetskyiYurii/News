//
//  UIAlert + extension.swift
//  News
//
//  Created by Baidetskyi Jurii on 06.02.2023.
//

import UIKit

extension UIViewController {
    
  func showAlert(message: String, title: String = "") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}
