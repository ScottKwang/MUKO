//
//  CreateController.swift
//  Unwind
//
//  Created by Alan Cao on 5/14/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import UIKit
import SDWebImage

private let createIdentifier = "CreateCell"

class CreateController: UITableViewController {
   
    // MARK: - Properties
    
    private let user: User
    
    private let captionCell: UITableViewCell = {
        let cell = UITableViewCell()
        return cell
    }()
    
    private let contentCell: UITableViewCell = {
        let cell = UITableViewCell()
        return cell
    }()
    
    private let captionTextView: CaptionTextView = {
        let textView = CaptionTextView()
        textView.placeholderLabel.text = " Caption"
        textView.placeholderLabel.font = UIFont(name: "Sarabun", size: 16)
        textView.font = UIFont(name: "Sarabun", size: 16)
        textView.isScrollEnabled = true
        return textView
    }()
    
    private let contentTextView: CaptionTextView = {
        let textView = CaptionTextView()
        textView.placeholderLabel.text = " Content"
        textView.placeholderLabel.font = UIFont(name: "Sarabun", size: 16)
        textView.font = UIFont(name: "Sarabun", size: 16)
        textView.isScrollEnabled = true
        return textView
    }()
    
    private let createHeader = CreateHeader()
    private let tapGesture = UITapGestureRecognizer()
    private let imagePicker = UIImagePickerController()
    
    private lazy var postButton: UIButton = {
        let button = Utilities().simpleButton(title: "Post", cornerRadius: 32 / 2)
        button.setDimensions(width: 64, height: 32)
        button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycles
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePostTapped() {
        guard let title = createHeader.titleTextView.text else { return }
        guard let caption = captionTextView.text  else { return }
        guard let content = contentTextView.text else { return }
        guard let image = createHeader.createImageView.image else { return }
        
        ArticleService.shared.postArticle(title: title, caption: caption, content: content, image: image) { (error, reference) in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        tableView.backgroundColor = .white
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        
        createHeader.createImageView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(handleImageViewTapped))
        
        configureNavigationUI()
        
        captionCell.contentView.addSubview(captionTextView)
        captionCell.contentView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        captionTextView.anchor(top: captionCell.contentView.topAnchor, left: captionCell.contentView.leftAnchor, bottom: captionCell.contentView.bottomAnchor, right: captionCell.contentView.rightAnchor, paddingLeft: 20, paddingBottom: 8, paddingRight: 20)
        
        contentCell.contentView.addSubview(contentTextView)
        contentCell.contentView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        contentTextView.anchor(top: contentCell.contentView.topAnchor, left: contentCell.contentView.leftAnchor, bottom: contentCell.contentView.bottomAnchor, right: contentCell.contentView.rightAnchor, paddingLeft: 20, paddingBottom: 8, paddingRight: 20)
    }
    
    func configureNavigationUI() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage() // Removes underline view of navigation

        let logoImageView = UIImageView(image: UIImage(named: "nav-logo"))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.setDimensions(width: 64, height: 64)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        navigationItem.titleView = logoImageView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: postButton)
    }
}

extension CreateController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0: return captionCell
            case 1: return contentCell
            default: fatalError("Cell indexPath doesn't exist")
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        createHeader.delegate = self
        return createHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 128
    }
}

extension CreateController: CreateHeaderDelegate {
    @objc func handleImageViewTapped() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

extension CreateController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let articleImage = info[.editedImage] as? UIImage else { return }
        createHeader.createImageView.image = articleImage
        
        dismiss(animated: true, completion: nil)
    }
}
