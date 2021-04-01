//
//  UIViewController+Extension.swift
//  InspiringPeople
//
//  Created by Zvonimir Medak on 01.04.2021..
//

import Foundation
import UIKit

public extension UIViewController {
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
