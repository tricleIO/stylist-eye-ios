//
//  LoginViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import SnapKit
import UIKit
import KVNProgress

class LoginViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: > private
    fileprivate let emailTextField = TextField()
    fileprivate let passwordTextField = TextField()

    fileprivate let backgorundImageView = ImageView()
    fileprivate let logoImageView = ImageView()

    fileprivate let loginButton = Button(type: .system)
    fileprivate let forgotPasswordButton = Button(type: .system)

    // MARK: - <Initialize>
    internal override func initializeElements() {
        super.initializeElements()

        backgorundImageView.image = #imageLiteral(resourceName: "background_image")

        // TODO: @MS
        emailTextField.attributedPlaceholder = NSAttributedString(
            string:StringContainer[.email],
            attributes:[NSForegroundColorAttributeName: Palette[custom: .appColor]]
        )
        emailTextField.textColor = Palette[custom: .appColor]
        emailTextField.tintColor = Palette[custom: .appColor]
        emailTextField.keyboardType = .emailAddress
        emailTextField.spellCheckingType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        let emailImageView = ImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 12))
        emailImageView.image = #imageLiteral(resourceName: "human_image")
        emailImageView.contentMode = .scaleAspectFit
        emailTextField.leftView = emailImageView
        emailTextField.leftViewMode = .always

        forgotPasswordButton.setTitle(StringContainer[.forgotPassword], for: .normal)
        forgotPasswordButton.tintColor = Palette[custom: .appColor]
        forgotPasswordButton.titleLabel?.font = SystemFont[.description]

        logoImageView.image = #imageLiteral(resourceName: "logo_image")
        logoImageView.contentMode = .scaleAspectFit

        // TODO: @MS
        let passwordImageView = ImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 12))
        passwordImageView.image = #imageLiteral(resourceName: "lock_image")
        passwordImageView.contentMode = .scaleAspectFit
        passwordTextField.textColor = Palette[custom: .appColor]
        passwordTextField.leftView = passwordImageView
        passwordTextField.leftViewMode = .always
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string:StringContainer[.password],
            attributes:[NSForegroundColorAttributeName: Palette[custom: .appColor]]
        )
        passwordTextField.tintColor = Palette[custom: .appColor]
        passwordTextField.isSecureTextEntry = true
        passwordTextField.addTarget(self, action: #selector(loginButtonTapped), for: .editingDidEndOnExit)

        loginButton.backgroundColor = Palette[custom: .appColor]
        loginButton.setTitle(StringContainer[.login], for: .normal)
        loginButton.tintColor = Palette[custom: .purple]
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.titleLabel?.font = SystemFont[.description]
    }

    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                backgorundImageView,
                logoImageView,
                emailTextField,
                passwordTextField,
                loginButton,
                forgotPasswordButton,
            ]
        )
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        backgorundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        emailTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.width.equalTo(view.frame.size.width - 60)
            make.height.equalTo(30)
        }

        forgotPasswordButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(loginButton.snp.bottom).offset(24)
            make.width.equalTo(view.frame.size.width - 60)
            make.height.equalTo(25)
        }

        logoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(emailTextField.snp.top).offset(-80)
            make.height.equalTo(100)
        }

        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.width.equalTo(view.frame.size.width - 60)
            make.height.equalTo(30)
        }

        loginButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.width.equalTo(view.frame.size.width - 60-16)
            make.height.equalTo(60)
        }
    }

    internal override func setupView() {
        super.setupView()

        view.backgroundColor = Palette[basic: .white]
    }

    internal override func customInit() {
        super.customInit()

        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    // MARK: - Actions
    func loginButtonTapped() {
        login()
    }

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }

    }

    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height / 2
            }
        }
    }

    // MARK: - Action methods
    private func login() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            KVNProgress.show()
            LoginCommand(email: email, password: password).executeCommand { data in
                switch data {
                case let .success(object: data, _, _, apiResponse: apiResponse):
                // TODO: @MS
                    switch apiResponse {
                    case .ok:
                        KVNProgress.showSuccess {
                            Keychains[.userEmail] = email
                            Keychains[.userPassword] = password
                            AccountSessionManager.manager.accountSession = AccountSession(response: data)
                            if let window = (UIApplication.shared.delegate as? AppDelegate)?.window {
                                window.rootViewController = MainTabBarController()
                            }
                        }
                    case .fail:
                        KVNProgress.showError(withStatus: StringContainer[.errorOccured])
                    }
                case .failure:
                    KVNProgress.showError()
                }
            }
        }
    }
}
