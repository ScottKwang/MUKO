//
//  UserController.swift
//  Unwind
//
//  Created by Alan Cao on 5/11/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "ArticleCell"

class UserController: UITableViewController {
    
    // MARK: - Properties
    
    private var user: User
    private var articles = [Articles]() {
        didSet { tableView.reloadData() }
    }
        
    // MARK: - Lifecycles
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUserArticles()
    }
    
    // MARK: - API
    
    func fetchUserArticles() {
        ArticleService.shared.fetchUserArticles(forUser: user) { (articles) in
            self.articles = articles
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        configureNavigationUI()
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureNavigationUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.font : UIFont(name: "Sarabun-Bold", size: 36)!]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage() // Removes underline view of navigation
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Profile" //  Will set this to the user's name?
    }
    
    func configureProfileHeader() -> UIView {
        let viewModel = ProfileHeaderViewModel(user: user)
        let profileHeader = ProfileHeader()
        profileHeader.fullnameLabel.text = viewModel.fullnameText
        profileHeader.usernameLabel.text = viewModel.usernameText
        return profileHeader
    }
}

extension UserController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ArticleCell
        cell.article = articles[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ArticlesController(article: articles[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        configureProfileHeader()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 152
    }
}
