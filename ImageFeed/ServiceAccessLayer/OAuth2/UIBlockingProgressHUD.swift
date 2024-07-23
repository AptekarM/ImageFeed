//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Maksim  on 06.07.2024.
//

import UIKit

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
    
    static func show() {
        DispatchQueue.main.async {
            guard let window = window else { return }
            
            let hud = UIActivityIndicatorView(style: .large)
            hud.color = .white
            hud.backgroundColor = UIColor(white: 0, alpha: 0.7)
            hud.layer.cornerRadius = 10
            hud.translatesAutoresizingMaskIntoConstraints = false
            hud.startAnimating()
            
            let blockingView = UIView()
            blockingView.backgroundColor = UIColor(white: 0, alpha: 0.7)
            blockingView.translatesAutoresizingMaskIntoConstraints = false
            blockingView.layer.cornerRadius = 10
            blockingView.tag = 999 // Use a tag to identify the HUD
            
            window.addSubview(blockingView)
            blockingView.addSubview(hud)
            
            NSLayoutConstraint.activate([
                blockingView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                blockingView.centerYAnchor.constraint(equalTo: window.centerYAnchor),
                blockingView.widthAnchor.constraint(equalToConstant: 100),
                blockingView.heightAnchor.constraint(equalToConstant: 100),
                
                hud.centerXAnchor.constraint(equalTo: blockingView.centerXAnchor),
                hud.centerYAnchor.constraint(equalTo: blockingView.centerYAnchor)
            ])
        }
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            guard let window = window else { return }
            window.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
        }
    }
}
