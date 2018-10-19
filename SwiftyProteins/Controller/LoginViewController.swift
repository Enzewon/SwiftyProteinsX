//
//  LoginViewController.swift
//  SwiftyProteins
//
//  Created by Danil Vdovenko on 3/27/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import UIKit
import LocalAuthentication
import SVProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {

    let loginView: LoginView = {
       
        let view = LoginView()
        
        return view
        
    }()
    
    let container: UIView = {
       
        let view = UIView()
        
        view.backgroundColor = UIColor.rgb(red: 69, green: 90, blue: 100, alpha: 1.0)
        view.layer.cornerRadius = 15
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()
    
    let touchIDButton: UIButton = {
       
        let button = UIButton()
        
        if (Device().isEnableID()) {
            
            let image = UIImage(named: "touchID")
            let imageWhite = UIImage(named: "touchID_white")
            
            button.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            button.setImage(image, for: .normal)
            button.setImage(imageWhite, for: .highlighted)
            button.addTarget(self, action: #selector(loginTouchID), for: .touchUpInside)
            button.contentMode = .center
            button.imageView?.contentMode = .scaleAspectFit
            
        }
        
        return button
        
    }()
    
    var database = Database()
    
    let device = Device()
    
    let request = Request(withKey: "", andSecret: "")
    
    let alert = UIAlertController(title: "Error", message: "Invalid Username", preferredStyle: UIAlertControllerStyle.alert)
    
    let alert2 = UIAlertController(title: "Error", message: "Empty field, type something", preferredStyle: UIAlertControllerStyle.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Login"
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        container.addSubview(loginView)
        container.addSubview(touchIDButton)
        
        container.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: loginView)
        container.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: touchIDButton)
        
        view.addSubview(container)
        
        view.addConstraintsWithFormat(format: "H:|-36-[v0]-36-|", views: container)
        
        if device.isEnableID() {
            container.addConstraintsWithFormat(format: "V:|-12-[v0]-12-[v1(44)]-12-|", views: loginView, touchIDButton)
        } else {
            container.addConstraintsWithFormat(format: "V:|-12-[v0]-12-|", views: loginView)
        }
        
        view.addCenterConstraints(views: container)
        
        request.basicRequest()
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        alert2.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        loginView.loginInput.delegate = self
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        loginRegular(sender: UITextField.self)
        
        return false
        
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 60
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += 60
            }
        }
        
    }
    
    func goToLigands() {
        
        let ligandsVC = LigandsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        ligandsVC.ligands = self.database.ligandsBase
        navigationController?.pushViewController(ligandsVC, animated: true)
        
    }

    @objc func loginRegular(sender: Any) {
        
        self.view.endEditing(true)
        
        if (loginView.loginInput.text?.isEmpty)! {
            self.present(self.alert2, animated: true, completion: nil)
        } else {
            if let username = loginView.loginInput.text?.trimmingCharacters(in: .whitespaces) {
                if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil || username == "" {
                    self.present(self.alert, animated: true, completion: nil)
                } else {
                    
                    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.show()
                    
                    if let token = self.request.token {
                        self.request.getUser(token: token, about: username, addUser: { [unowned self] (response, error) in
                            if error != nil {
                                SVProgressHUD.dismiss()
                                self.displayError()
                            }
                            if let response = response {
                                if !response.isEmpty {
                                    self.database.readFromFile()
                                    DispatchQueue.main.async {
                                        SVProgressHUD.dismiss()
                                        self.goToLigands()
                                    }
                                } else {
                                    SVProgressHUD.dismiss()
                                       self.displayError()
                                }
                            }
                        })
                    }
                    
                }
            }
        }
        
    }
    
    func displayError() {
        let alert = UIAlertController(title: "Can't verify 42 login", message: "Error occured, invalid login or check your internet connection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func loginTouchID(sender: UIButton!) {
        
        let authContex = LAContext()
        
        self.view.endEditing(true)
        
        authContex.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "For entering instead 42 login", reply: { (success, error) in
            
            if success {
                
                self.database.readFromFile()
                
                DispatchQueue.main.async {
                    self.goToLigands()
                }
                
            }
            
        })
        
    }

}

