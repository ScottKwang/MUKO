//
//  ArticlesController.swift
//  Unwind
//
//  Created by Alan Cao on 5/17/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import UIKit
import SDWebImage

class ArticlesController: UIViewController {
    
    // MARK: - Properties
    
    private var article: Articles
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Sarabun-SemiBold", size: 18)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Sarabun", size: 16)
        return label
    }()
    
    private let userProfileImage: UIImageView = {
        let imageView = Utilities().simpleImageView(image: UIImage(named: "user"), cornerRadius: 44 / 2, borderWidth: 0.3)
        imageView.contentMode = .center
        imageView.setDimensions(width: 44, height: 44)
        return imageView
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Sarabun", size: 20)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Sarabun", size: 16)
        label.textColor = .gray
        return label
    }()
    
    private lazy var articleImage: UIImageView = {
        let imageView = Utilities().simpleImageView(image: UIImage(named: "sign-in"), cornerRadius: 10, borderWidth: 0.3)
        imageView.setDimensions(width: view.frame.width - 40, height: view.frame.height / 5)
        return imageView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Sarabun", size: 18)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(article: Articles) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        
        if article.isFavorited {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorites-filled"), style: .plain, target: self, action: #selector(handleFavorite))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorites"), style: .plain, target: self, action: #selector(handleFavorite))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
        
    // MARK: - Selectors
    
    @objc func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleFavorite() {
        if !article.isFavorited {
            ArticleService.shared.favoriteArticle(article: article) { (error, reference) in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                self.configure()
                self.navigationItem.rightBarButtonItem?.image = UIImage(named: "favorites-filled")
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationUI()
        
        let userStack = UIStackView(arrangedSubviews: [userProfileImage, fullnameLabel, dateLabel])
        userStack.axis = .horizontal
        userStack.spacing = 16
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, captionLabel, userStack, articleImage, contentLabel])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(scrollView)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        scrollView.addSubview(stack)
        stack.anchor(top: scrollView.topAnchor, left: view.leftAnchor, bottom: scrollView.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
    }
    
    func configureNavigationUI() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage() // Removes underline view of navigation

        let logoImageView = UIImageView(image: UIImage(named: "nav-logo"))
        logoImageView.contentMode = .scaleAspectFill

        navigationItem.titleView = logoImageView
    }
    
    func configure() {
        let articlesViewModel = ArticlesViewModel(article: article)
        
        titleLabel.text = articlesViewModel.title
        captionLabel.text = articlesViewModel.caption
        fullnameLabel.text = articlesViewModel.fullnameLabel
        dateLabel.text = articlesViewModel.timestamp
        articleImage.sd_setImage(with: article.image)
        contentLabel.attributedText = articlesViewModel.content
    }
}
