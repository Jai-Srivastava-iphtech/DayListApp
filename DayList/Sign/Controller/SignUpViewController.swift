//
//  SignUpViewController.swift
//  project-OrganicMindUI
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var eyeButton1: UIButton!
    @IBOutlet weak var eyeButton2: UIButton!


    // MARK: - Properties
    private var isPasswordVisible = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        hideKeyboardWhenTappedAround()
    }

    private func setupUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self

        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true

        eyeButton1.setImage(UIImage(named: "eye-slashed"), for: .normal)
        eyeButton2.setImage(UIImage(named: "eye-slashed"), for: .normal)

        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .next
        confirmPasswordTextField.returnKeyType = .done
    }

    // MARK: - Eye Button
    @IBAction func eyeButtonTapped(_ sender: UIButton) {
        togglePasswordVisibility()
    }

    private func togglePasswordVisibility() {
        isPasswordVisible.toggle()

        let shouldShow = isPasswordVisible

        // Toggle BOTH password fields
        passwordTextField.isSecureTextEntry = !shouldShow
        confirmPasswordTextField.isSecureTextEntry = !shouldShow

        // SAME icon for BOTH eye buttons
        let imageName = shouldShow
            ? "eye-removebg-preview"
            : "eye-slashed"

        eyeButton1.setImage(UIImage(named: imageName), for: .normal)
        eyeButton2.setImage(UIImage(named: imageName), for: .normal)

        refreshTextField(passwordTextField)
        refreshTextField(confirmPasswordTextField)
    }

    private func refreshTextField(_ textField: UITextField) {
        let text = textField.text
        textField.text = nil
        textField.text = text
    }

    // MARK: - Sign Up
    @IBAction func signUpTapped(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let confirm = confirmPasswordTextField.text ?? ""

        if email.isEmpty || password.isEmpty || confirm.isEmpty {
            showAlert("Please fill all fields")
            return
        }

        if password != confirm {
            showAlert("Passwords do not match")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                self.showAlert(error.localizedDescription)
                return
            }

            let alert = UIAlertController(
                title: "Success",
                message: "Account created successfully",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.goToSignIn()
            })

            self.present(alert, animated: true)
        }
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    // MARK: - Navigation
    private func goToSignIn() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")

        let nav = UINavigationController(rootViewController: signInVC)

        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = nav
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }

    // MARK: - Helpers
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
