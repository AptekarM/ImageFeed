//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Maksim  on 26.05.2024.
//

import UIKit
final class ProfileViewController: UIViewController {
        private var label: UILabel?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let profileImage = UIImage(named: "avatar")
            let imageView = UIImageView(image: profileImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            let avatar = UILabel()
            avatar.text = "Екатерина Новикова"
            avatar.textColor = .ypWhiteIOS
            avatar.font = UIFont.boldSystemFont(ofSize: 23)
            avatar.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(avatar)
            avatar.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
            avatar.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
            self.label = avatar
            
            let socialLabel = UILabel()
            socialLabel.text = "@ekaterina_nov"
            socialLabel.textColor = .ypGrayIOS
            socialLabel.font = UIFont.systemFont(ofSize: 13)
            socialLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(socialLabel)
            socialLabel.leadingAnchor.constraint(equalTo: avatar.leadingAnchor).isActive = true
            socialLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 8).isActive = true


            let greetingLabel = UILabel()
            greetingLabel.text = "Hello, world!"
            greetingLabel.textColor = .ypWhiteIOS
            greetingLabel.font = UIFont.systemFont(ofSize: 13)
            greetingLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(greetingLabel)
            greetingLabel.leadingAnchor.constraint(equalTo: avatar.leadingAnchor).isActive = true
            greetingLabel.topAnchor.constraint(equalTo: socialLabel.bottomAnchor, constant: 8).isActive = true
            
            let button = UIButton.systemButton(
                with: UIImage(named: "logout_button")!,
                target: self,
                action: #selector(Self.didTapButton)
            )
            button.tintColor = .ypRedIOS
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        }
        
        @objc
        private func didTapButton() {
            
            for view in view.subviews {
                if view is UILabel {
                    view.removeFromSuperview()
                }
            }
        }
    }







