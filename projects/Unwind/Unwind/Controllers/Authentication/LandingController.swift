//
//  LandingController.swift
//  Unwind
//
//  Created by Alan Cao on 5/6/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import UIKit

class LandingController: UIViewController {
   
    // MARK: - Properties
    
    private let landingBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "landing")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = Utilities().makeLandingTitle(text: "Unwind", font: "Sarabun-ExtraBold", size: 56)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = Utilities().makeLandingTitle(text: "Peaceful thinking.", font: "Sarabun-Regular", size: 24)
        return label
    }()
    
    private let signInButton: UIButton = {
        let button = Utilities().simpleButton(title: "Sign in with Email", cornerRadius: 52 / 2)
        button.addTarget(self, action: #selector(handleSignInTapped), for: .touchUpInside)
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = Utilities().attributedButton(firstPart: "Don't have an account? ", secondPart: "Sign up!")
        button.addTarget(self, action: #selector(handleSignUpTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleSignInTapped() {
        let controller = SignInController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleSignUpTapped() {
        let controller = SignUpController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationUI()
        
        view.addSubview(landingBackground)
        landingBackground.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, captionLabel])
        stack.axis = .vertical
        view.addSubview(stack)
        stack.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: view.frame.height / 3)
        
        view.addSubview(signInButton)
        signInButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20, height: 52)
        
        view.addSubview(signUpButton)
        signUpButton.centerX(inView: view)
        signUpButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 8)
    }
    
    func configureNavigationUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.font : UIFont(name: "Sarabun-Bold", size: 36)!]
    }
}
