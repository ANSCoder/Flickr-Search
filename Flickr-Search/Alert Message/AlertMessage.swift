//
//  AlertMessage.swift
//  Flickr-Search
//
//  Created by Anand Nimje on 07/07/18.
//  Copyright © 2018 Anand. All rights reserved.
//

import UIKit

protocol AlertMessage: class {
    typealias Events = (_ retry: Bool)-> Void
    
    func showAlertWithError(_ message: String, completionHandler: @escaping Events)
}

extension AlertMessage where Self: UIViewController{
    
    //MARK:- Show Error Alert
    func showAlertWithError(_ message: String, completionHandler: @escaping Events) {
        let alert = UIAlertController(title: NSLocalizedString("Opps!", comment: ""),
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""),
                                      style: .cancel,
                                      handler: nil))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""),
                                      style: .default,
                                      handler: { _ in completionHandler(true) }))
        present(alert, animated: true, completion: nil)
    }
}

