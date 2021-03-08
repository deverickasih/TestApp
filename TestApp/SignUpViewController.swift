//
//  SignUpViewController.swift
//  TestApp
//
//  Created by JAN FREDRICK on 08/03/21.
//  Copyright © 2021 JFSK. All rights reserved.
//

import UIKit
import CoreData

class SignUpViewController : UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var emailTF, userTypeTF, pass1TF, pass2TF : UITextField!
    
    let pickerData = ["Normal", "Admin"]
    
    var topPadding : CGFloat = 0
    var bottomPadding : CGFloat = 0
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        self.title = "Sign Up Page"
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let objectWidth = screenWidth - 40
        
        emailTF = UITextField(frame: CGRect(x: 20, y: topPadding + navBarHeight + 30, width: objectWidth, height: 40))
        view.addSubview(emailTF)
        
        emailTF.delegate = self
        emailTF.placeholder = "Set Username here"
        emailTF.textAlignment = .center
        emailTF.setBorderColor(color: .lightGray)
        
        userTypeTF = UITextField(frame: CGRect(x: 20, y: emailTF.frame.origin.y + 50, width: objectWidth, height: 40))
        view.addSubview(userTypeTF)
        
        userTypeTF.delegate = self
        userTypeTF.placeholder = "Set User Type here"
        userTypeTF.textAlignment = .center
        userTypeTF.setBorderColor(color: .lightGray)
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        userTypeTF.inputView = pickerView
        
        pass1TF = UITextField(frame: CGRect(x: 20, y: userTypeTF.frame.origin.y + 50, width: objectWidth, height: 40))
        view.addSubview(pass1TF)
        
        pass1TF.delegate = self
        pass1TF.placeholder = "Type Password here"
        pass1TF.textAlignment = .center
        pass1TF.setBorderColor(color: .lightGray)
        
        pass2TF = UITextField(frame: CGRect(x: 20, y: pass1TF.frame.origin.y + 50, width: objectWidth, height: 40))
        view.addSubview(pass2TF)
        
        pass2TF.delegate = self
        pass2TF.placeholder = "Re-type Password here"
        pass2TF.textAlignment = .center
        pass2TF.setBorderColor(color: .lightGray)
        
        let newUserB = UIButton(frame: CGRect(x: 20, y: pass2TF.frame.origin.y + 60, width: objectWidth, height: 50))
        view.addSubview(newUserB)
        
        newUserB.backgroundColor = .orange
        newUserB.setTitle("Create New User", for: .normal)
        
        newUserB.addTarget(self, action: #selector(createNewUserNow), for: .touchUpInside)
        
        ///Touch Screen to release keyboards / pickerviews
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func createNewUserNow() {
        
        var errorMsg = ""
        
        if emailTF.text == "" {
            errorMsg += "\nUsername"
        }
        if userTypeTF.text == "" {
            errorMsg += "\nUser Type"
        }
        if pass1TF.text == "" {
            errorMsg += "\nPassword"
        }
        if pass2TF.text == "" {
            errorMsg += "\nRe-type Password"
        }
        
        if errorMsg != "" {
            showMsg(title: "Missing Field(s)", msg: "Kindly fill in the following :" + errorMsg, buttonString: "Understood")
            /*let alertVC = UIAlertController(title: "Missing Field(s)", message: "Kindly fill in the following :" + errorMsg, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Understood", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)*/
            return
        }
        
        if pass1TF.text != pass2TF.text {
            showMsg(title: "Password Missmatch", msg: "Kindly make sure your password are the same.", buttonString: "Understood")
            /*let alertVC = UIAlertController(title: "Password Missmatch", message: "Kindly make sure your password are the same.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Understood", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)*/
            return
        }
        
        addNewEntry(username: emailTF.text!, password: pass1TF.text!, userType: userTypeTF.text!)
    }
    
    func addNewEntry(username: String, password: String, userType: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(username, forKey: "username") // for username
        user.setValue(userType, forKey: "usertype") // for usertype
        user.setValue(password, forKey: "password") // for password
        
        do {
            try managedContext.save()
            
            showMsg(title: "Success", msg: "Added new record with username : \"\(username)\"", buttonString: "Thank you")
            
            /*let alertVC = UIAlertController(title: "Success", message: "Added new record with username : \"\(username)\"", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Thank you", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)*/
            
        } catch let error as NSError {
            showMsg(title: "Error DB Write", msg: error.localizedDescription, buttonString: "Understood")
        }
        
    }
    
    /// TextField Delegate Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// PickerView Delegate & DataSource Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userTypeTF.text = pickerData[row]
    }
    
}

/// View Controller Extension Functions
extension UIViewController {

    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var navBarHeight: CGFloat {
        return (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    func showMsg(title: String, msg: String, buttonString: String) {
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: buttonString, style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
