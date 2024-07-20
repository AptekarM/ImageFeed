//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Maksim  on 26.05.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var profileImageView: UIImageView?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateProfileDetails()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        
        updateAvatar()
    }
    
    private func updateProfileDetails() {
        guard let profile = ProfileService.shared.profile else { return }
        nameLabel?.text = profile.name
        loginNameLabel?.text = profile.loginName
        descriptionLabel?.text = profile.bio
    }
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL)
        else { return }
        
        let placeholderImage = UIImage(named: "placeholder.jpeg")
        
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        
        profileImageView?.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .cacheOriginalImage,
                .backgroundDecode,
                .forceRefresh,
                .scaleFactor(UIScreen.main.scale)
                
            ]
        )
    }
    
    private func setupUI() {

        view.backgroundColor = .ypBlackIOS

        let ProfileImage = UIImage()
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
       
        
        self.profileImageView = imageView
        
        let nameLabel = UILabel()
        nameLabel.textColor = .ypWhiteIOS
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        self.nameLabel = nameLabel
        
        let loginNameLabel = UILabel()
        loginNameLabel.textColor = .ypGrayIOS
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        self.loginNameLabel = loginNameLabel
        
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .ypWhiteIOS
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        self.descriptionLabel = descriptionLabel
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "logout_button"), for: .normal)
        button.tintColor = .ypRedIOS
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapButton() {
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

