//
//  RegisterController.swift
//  WatchChainIOS
//
//  Created by Alexej K on 05.01.23.
//

import UIKit

class RegisterController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    
    @IBOutlet weak var googleSignUpButton: UIButton!
    @IBOutlet weak var appleSignUpButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var backgroundImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImg.loadGif(name: "giphyImg")
        
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        passwordField.isSecureTextEntry = true
        repeatPasswordField.delegate = self
        repeatPasswordField.isSecureTextEntry = true
        signUpButton.isEnabled = false
        keyboardDissmissable()
        
        self.emailField.keyboardType = .emailAddress
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // KEYBOARD OVERLAPS VIEW
    @objc func keyBoardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 && (repeatPasswordField.isFirstResponder) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // DISMISS KEYBOARD OUTSIDE
    @objc func dismissKeyboardTouchOutside() {
        self.view.endEditing(true)
    }
    
    func keyboardDissmissable() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    /*@IBAction func didTapGoogleSignUp(_ sender: Any) {
    }
    
    @IBAction func didTapAppleSignUp(_ sender: Any) {
    }*/
    
    @IBAction func didTapSignUp() {
        let name = usernameField.text ?? ""
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        let repeatpassword = repeatPasswordField.text ?? ""
        _ = User(name: name, email: email, password: password, repeatpassword: repeatpassword)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textEditingChange() {
        if usernameField.text == "" || emailField.text == "" || passwordField.text == "" || repeatPasswordField.text == "" {
            print("Not all fields are filled out!!!")
            signUpButton.isEnabled = false
        } else {
            signUpButton.isEnabled = true
        }
    }
    
}

extension RegisterController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.scheme == "terms" {
            self.showWebViewerController(with: "https://policies.google.com/terms?hl=en")
        } else if URL.scheme == "privacy" {
            self.showWebViewerController(with: "https://policies.google.com/privacy?hl=en")
        }
        return true
    }
    
    private func showWebViewerController(with urlString: String) {
        let vc = WebViewerController(with: urlString)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
}
