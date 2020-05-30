//
//  FeedController.swift
//  Unwind
//
//  Created by Alan Cao on 5/11/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import UIKit
import Firebase

private let articleIdentifier = "ArticleCell"

class FeedController: UITableViewController {
    
    // MARK: - Properties
    
    var user: User?
    
    var articles = [Articles]() {
        didSet { tableView.reloadData() }
    }
    
    private let createButton: UIButton = {
        let button = Utilities().createButton(image: UIImage(named: "create"))
        button.addTarget(self, action: #selector(handleCreateTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchArticles()
        configureNavigationUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchCurrentUser()
    }
    
    // MARK: - API
    
    func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchCurrentUser(uid: uid) { (user) in
            self.user = user
        }
    }
    
    func fetchArticles() {
        ArticleService.shared.fetchArticles { (articles) in
            self.articles = articles
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleCreateTapped() {
        guard let user = user else { return }
        
        let createController = UINavigationController(rootViewController: CreateController(user: user))
        createController.modalPresentationStyle = .fullScreen
        present(createController, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
                
        tableView.register(ArticleCell.self, forCellReuseIdentifier: articleIdentifier)
        
        view.addSubview(createButton)
        createButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 20, paddingRight: 20)
    }
    
    func configureNavigationUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.font : UIFont(name: "Sarabun-Bold", size: 36)!]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage() // Removes underline view of navigation
        navigationItem.title = "Articles"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FeedController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: articleIdentifier, for: indexPath) as! ArticleCell
        cell.article = articles[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ArticlesController(article: articles[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}
