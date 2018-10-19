//
//  LoginView.swift
//  SwiftyProteins
//
//  Created by Danil Vdovenko on 3/27/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    let loginLabel: UILabel = {
        
        let textLabel = UILabel()
        
        textLabel.text = "Username"
        textLabel.textColor = .white
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return textLabel
        
    }()
    
    let loginInput: UITextField = {
        
        let textField = UITextField()
        
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.placeholder = "Enter 42 login"
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
        
    }()
    
    let loginButton: UIButton = {
       
        let button = UIButton()
        
        button.setBackgroundColor(color: UIColor.rgb(red: 0, green: 150, blue: 136, alpha: 0.9), forState: .normal)
        button.setTitle("Sign In", for: .normal)
        button.addTarget(self, action: #selector(LoginViewController.loginRegular), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    func setupViews() {
        
        addSubview(loginInput)
        addSubview(loginLabel)
        addSubview(loginButton)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: loginLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: loginInput)
        addConstraintsWithFormat(format: "H:|[v0]|", views: loginButton)
        addConstraintsWithFormat(format: "V:|[v0(36)]-12-[v1(36)]-24-[v2(40)]|", views: loginLabel, loginInput, loginButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
