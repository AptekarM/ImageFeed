//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Maksim  on 13.06.2024.
//

import UIKit
import ProgressHUD

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
            else {
                assertionFailure("Failed to prepare for \(ShowWebViewSegueIdentifier)")
                return
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        
        OAuth2Service.shared.fetchAuthToken(with: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.saveToken(token)
                self?.delegate?.authViewController(self!, didAuthenticateWithCode: code)
                self?.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print("Error fetching auth token: \(error)")
                self?.showErrorAlert()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

