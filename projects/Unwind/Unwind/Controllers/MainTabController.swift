//
//  MainTabController.swift
//  Unwind
//
//  Created by Alan Cao on 5/11/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
   
    // MARK: - Properties
    
    var user: User? {
        didSet { configureTabs() }
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        logUserOut() // Uncomment this to log out
        view.backgroundColor = .white
        authenticateUser()
    }
    
    // MARK: - API
    
    func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchCurrentUser(uid: uid) { (user) in
            self.user = user
        }
    }
    
    // MARK: - Helpers
    
    func configureTabs() {
        // Embed controllers in navigation controller
        let articles = FeedController()
        let navItem1 = createTabControllers(image: UIImage(named: "articles"), title: "Articles", viewController: articles)
        
        let search = SearchController()
        let navItem2 = createTabControllers(image: UIImage(named: "search"), title: "Search", viewController: search)
        
        let profile = UserController(user: self.user!)
        let navItem3 = createTabControllers(image: UIImage(named: "user"), title: "Profile", viewController: profile)
        
        let favorites = FavoritesController(user: self.user!)
        let navItem4 = createTabControllers(image: UIImage(named: "favorites"), title: "Favorites", viewController: favorites)

        let notifications = NotificationsController()
        let navItem5 = createTabControllers(image: UIImage(named: "notifications"), title: "Notifications", viewController: notifications)

        viewControllers = [navItem1, navItem2, navItem3, navItem4, navItem5]
        
        tabBar.barTintColor = .white
        tabBar.unselectedItemTintColor = .black
    }
    
    func createTabControllers(image: UIImage?, title: String, viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.tabBarItem.image = image
        navigation.title = title
        
        return navigation
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LandingController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            fetchCurrentUser()
        }
    }
    
    // Temporary log out function to test auth
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Failed to log out with error \(error.localizedDescription)")
        }
    }
}
