//
//  NotificationsController.swift
//  Unwind
//
//  Created by Alan Cao on 5/11/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import UIKit

class NotificationsController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationUI()
    }
    
    func configureNavigationUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.font : UIFont(name: "Sarabun-Bold", size: 36)!]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage() // Removes underline view of navigation
        navigationItem.title = "Notifications"
    }
}
