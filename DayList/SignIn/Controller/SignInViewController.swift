//
//  SignInViewController.swift
//  project-OrganicMindUI
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeButton: UIButton!

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

        passwordTextField.isSecureTextEntry = true
        eyeButton.setImage(UIImage(named: "eye-slashed"), for: .normal)

        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
    }

    // MARK: - Eye Button
    @IBAction func eyeButtonTapped(_ sender: UIButton) {
        isPasswordVisible.toggle()

        passwordTextField.isSecureTextEntry = !isPasswordVisible

        let imageName = isPasswordVisible
            ? "eye-removebg-preview"
            : "eye-slashed"

        sender.setImage(UIImage(named: imageName), for: .normal)

        refreshTextField(passwordTextField)
    }

    private func refreshTextField(_ textField: UITextField) {
        let text = textField.text
        textField.text = nil
        textField.text = text
    }

    // MARK: - Sign In
    @IBAction func signInTapped(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        if email.isEmpty || password.isEmpty {
            showAlert("Enter email & password")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                self.showAlert(error.localizedDescription)
                return
            }
            self.goToHome()
        }
    }

    private func goToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TodayViewController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    // MARK: - Helpers
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
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
