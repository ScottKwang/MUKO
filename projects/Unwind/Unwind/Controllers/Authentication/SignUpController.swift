//
//  SignUpController.swift
//  Unwind
//
//  Created by Alan Cao on 5/7/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUpController: UIViewController {
    
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
    
    private lazy var fullnameViewContainer: UIView = {
        let image = UIImage(named: "username")!
        let view = Utilities().inputContainerView(withImage: image, textField: fullnameTextField)
        return view
    }()
    
    private lazy var usernameViewContainer: UIView = {
        let image = UIImage(named: "username")
        let view = Utilities().inputContainerView(withImage: image, textField: usernameTextField)
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
    
    private let fullnameTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Full Name")
        return textField
    }()
    
    private let usernameTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Username")
        return textField
    }()
    
    private let signUpButton: UIButton = {
        let button = Utilities().simpleButton(title: "Sign Up", cornerRadius: 52 / 2)
        button.addTarget(self, action: #selector(handleSignUpTapped), for: .touchUpInside)
        return button
    }()
    
    private let signUpImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sign-up")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let tapGesure = UITapGestureRecognizer()
    
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
    
    @objc func handleSignUpTapped() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
                
        AuthService.shared.signUpUser(email: email, password: password) { (result, error) in
            if let error = error {
                let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            guard let uid = result?.user.uid else { return }
            
            let data = ["email": email, "username": username, "fullname": fullname]
            REF_USERS.child(uid).updateChildValues(data)
            
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
        view.addGestureRecognizer(tapGesure)
        tapGesure.addTarget(self, action: #selector(dismissKeyboard))
        title = "Sign Up"
                
        let stack = UIStackView(arrangedSubviews: [emailViewContainer, passwordViewContainer, fullnameViewContainer, usernameViewContainer])
        stack.axis = .vertical
        stack.spacing = 12
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(signUpImageView)
        signUpImageView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: view.frame.height / 2.5)
        
        view.addSubview(signUpButton)
        signUpButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 20, paddingRight: 20, height: 52)
    }
}
