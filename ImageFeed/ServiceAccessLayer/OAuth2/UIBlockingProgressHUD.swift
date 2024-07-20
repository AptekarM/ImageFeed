//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Maksim  on 06.07.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        guard let window = window else { return }
        ProgressHUD.animate("Loading...")
        window.isUserInteractionEnabled = false
    }
    
    static func dismiss() {
        guard let window = window else { return }
        ProgressHUD.dismiss()
        window.isUserInteractionEnabled = true
    }
}

