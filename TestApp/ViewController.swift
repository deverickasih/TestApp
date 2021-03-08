//
//  ViewController.swift
//  TestApp
//
//  Created by JAN FREDRICK on 08/03/21.
//  Copyright © 2021 JFSK. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    var topPadding : CGFloat = 0
    var bottomPadding : CGFloat = 0
    
    var emailTF, passwordTF : UITextField!
    
    var usersArray : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.topItem?.title = "Log In Page"
        
        let window = UIApplication.shared.windows[0]
        topPadding = window.safeAreaInsets.top
        bottomPadding = window.safeAreaInsets.bottom
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let objectWidth = screenWidth - 40
        
        emailTF = UITextField(frame: CGRect(x: 20, y: topPadding + navBarHeight + 30, width: objectWidth, height: 40))
        view.addSubview(emailTF)
        
        emailTF.delegate = self
        emailTF.placeholder = "Username here.."
        emailTF.textAlignment = .center
        emailTF.setBorderColor(color: .lightGray)
        
        passwordTF = UITextField(frame: CGRect(x: 20, y: emailTF.frame.origin.y + 50, width: objectWidth, height: 40))
        view.addSubview(passwordTF)
        
        passwordTF.delegate = self
        passwordTF.placeholder = "Password here.."
        passwordTF.textAlignment = .center
        passwordTF.isSecureTextEntry = true
        passwordTF.setBorderColor(color: .lightGray)
        
        let loginB = UIButton(frame: CGRect(x: 20, y: passwordTF.frame.origin.y + 60, width: objectWidth, height: 50))
        view.addSubview(loginB)
        
        loginB.backgroundColor = .systemOrange
        loginB.setTitle("Login", for: .normal)
        
        loginB.addTarget(self, action: #selector(loginNow), for: .touchUpInside)
        
        let signUpB = UIButton(frame: CGRect(x: 20, y: loginB.frame.origin.y + 70, width: objectWidth, height: 50))
        view.addSubview(signUpB)
        
        signUpB.setTitle("Sign Up", for: .normal)
        signUpB.setTitleColor(.black, for: .normal)
        signUpB.setBorderColor(color: .black)
        
        signUpB.addTarget(self, action: #selector(toSignUpPage), for: .touchUpInside)
        
        ///Touch Screen to release keyboards / pickerviews
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        /// Get users list from local DB
        usersArray = loadUserListFromDatabase()
        
    }
    
    @objc func toSignUpPage() {
        let nvc = SignUpViewController()
        nvc.topPadding = topPadding
        nvc.bottomPadding = bottomPadding
        self.navigationController?.pushViewController(nvc, animated: true)
    }
    
    @objc func loginNow() {
        
        if emailTF.text == "" || passwordTF.text == "" {
            showMsg(title: "Missing Fields", msg: "Please ensure all fields are filled.", buttonString: "Understood")
            return
        }
        
        var rowNum = -1
        var objectData : NSManagedObject! = nil
        
        for i in 0..<usersArray.count {
            
            objectData = usersArray[i]
            
            let userNameGet = objectData.value(forKey: "username") as! String
            
            if emailTF.text == userNameGet {
                rowNum = i
                break
            }
            
        }
        
        if rowNum == -1 || objectData == nil {
            showMsg(title: "User Not Found", msg: "Please Sign Up if you are a new user. Your username was not found in our database.", buttonString: "Understood")
        }else{
            /// objectData shouldn't be nil here
            let userPassGet = objectData.value(forKey: "password") as! String
            
            if userPassGet != passwordTF.text {
                showMsg(title: "Login Error", msg: "Wrong Password.", buttonString: "Understood")
            }else{
                
                let userTypeGet = objectData.value(forKey: "usertype") as! String
                
                if userTypeGet.lowercased() == "normal" || userTypeGet.lowercased() == "admin" {
                    let nvc = PageViewController()
                    nvc.topPadding = topPadding
                    nvc.bottomPadding = bottomPadding
                    nvc.username = emailTF.text!
                    nvc.role = userTypeGet
                    nvc.usersArray = usersArray
                    self.navigationController?.pushViewController(nvc, animated: true)
                }else{
                    showMsg(title: "Login Error", msg: "Unidentified User Type", buttonString: "Understood")
                }
                
            }
        }
        
    }
    
    func loadUserListFromDatabase() -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result as! [NSManagedObject]
        } catch let error as NSError {
            showMsg(title: "Error DB Read", msg: error.localizedDescription, buttonString: "Understood")
            return []
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension UIView {
    func setBorderColor(color: UIColor){
        self.layer.borderWidth = 1.5
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = 5.0
    }
}

