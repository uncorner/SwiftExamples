//
//  LoginViewController.swift
//  FirebaseApp
//
//  Created by denis2 on 24.01.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    let showTasksSegue = "showTasksSegue"
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        messageLabel.alpha = 0
        
        self.ref = Database.database().reference(withPath: "users")
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.showTasksSegue)!, sender: nil)
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loginTextField.text = ""
        passwordTextField.text = ""
    }
    
    @objc private func keyboardDidShow(notification: NSNotification){
        guard let userInfo = notification.userInfo else {return}
        let kbdSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbdSize.height)
        
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbdSize.height, right: 0)
    }
    
    @objc private func keyboardDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    private func dispalyWarningLabel(text: String) {
        messageLabel.text = text
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: { [weak self] in
            self?.messageLabel.alpha = 1
            
        }, completion: { [weak self] complete in
            self?.messageLabel.alpha = 0
        })
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let email = self.loginTextField.text, let password = self.passwordTextField.text, email != "", password != "" else {
            dispalyWarningLabel(text: "Info is incorrect")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            if error != nil {
                self?.dispalyWarningLabel(text: "Error occured")
                return
            }
            
            if (authResult?.user != nil) {
                self?.performSegue(withIdentifier: (self?.showTasksSegue)!, sender: nil)
                return
            }
            
            self?.dispalyWarningLabel(text: "No such user")
        }
        
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let email = self.loginTextField.text, let password = self.passwordTextField.text, email != "", password != "" else {
            dispalyWarningLabel(text: "Info is incorrect")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard error == nil, authResult?.user != nil else {
                print(error?.localizedDescription)
                return
            }
            
            let userRef = self.ref.child((authResult?.user.uid)!)
            userRef.setValue(["email": authResult?.user.email])
        }
    }

    
}
