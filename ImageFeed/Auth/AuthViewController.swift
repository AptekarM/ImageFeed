//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Maksim  on 13.06.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    private let ShowWebViewSegueIdentifier = "ShowWebView"

    weak var delegate: AuthViewControllerDelegate?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuth2Service.shared.fetchAuthToken(with: code) { [weak self] result in
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.saveToken(token)
                self?.delegate?.authViewController(self!, didAuthenticateWithCode: code)
                self?.dismiss(animated: true, completion: nil)
            case .failure(let error):
                // Обработка ошибки
                print("Error fetching auth token: \(error)")
                // Возможно, стоит показать пользователю уведомление об ошибке
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
