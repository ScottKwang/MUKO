//
//  SignInController.swift
//  Unwind
//
//  Created by Alan Cao on 5/6/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import UIKit
import Firebase

class SignInController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var emailViewContainer: UIView = {
        let image = UIImage(named: "email")!
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordViewContainer: UIView = {
        let image = UIImage(named: "password")!
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Email")
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let signInButton: UIButton = {
        let button = Utilities().simpleButton(title: "Sign In", cornerRadius: 52 / 2)
        button.addTarget(self, action: #selector(handleSignInTapped), for: .touchUpInside)
        return button
    }()
    
    private let signInImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sign-in")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
        
    private let tapGesture = UITapGestureRecognizer()
    
    // MARK: - Lifecycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleSignInTapped() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        AuthService.shared.signInUser(email: email, password: password) { (result, error) in
            if let error = error {
                let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let tab = window.rootViewController as? MainTabController else { return }
            tab.authenticateUser()

            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        view.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(dismissKeyboard))
        title = "Sign In"
            
        let stack = UIStackView(arrangedSubviews: [emailViewContainer, passwordViewContainer])
        stack.axis = .vertical
        stack.spacing = 12
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(signInImageView)
        signInImageView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: view.frame.height / 2)
        
        view.addSubview(signInButton)
        signInButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 20, paddingRight: 20, height: 52)
    }
}
