//
//  MainViewController.swift
//  SimpleChat
//
//  Created by NguyenCuong on 1/19/19.
//  Copyright © 2019 NguyenCuong. All rights reserved.
//

import UIKit
import Firebase
class MainViewController: UIViewController {

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPWD: UIButton!
    @IBOutlet weak var uvBackgroundLogin: UIView!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPWD: UITextField!
    @IBAction func btnALogin(_ sender: Any) {
        let btnOK: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPWD.text!) { (user, error) in
            // ...
            if(error != nil){
                let alert:UIAlertController = UIAlertController(title: "Notification", message: "The email or password you entered is not correct", preferredStyle: .alert)
                alert.addAction(btnOK)
                self.present(alert, animated: true, completion: nil)
                return
            }
            else{
                self.GotoScreen()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.IsLogin()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        btnForgotPWD.skin(b: false)
        btnLogin.skin(b: true)
        btnRegister.skin(b: true)
        uvBackgroundLogin.Login()
        
        //self.IsLogin()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func IsLogin(){
        if Auth.auth().currentUser != nil {
            // User is signed in.
            //print("\(String(describing: Auth.auth().currentUser!.photoURL?.path))--------------------")
            self.GotoScreen()
            //print("Da dang nhap")
        } else {
            // No user is signed in.
            print("Chua dang nhap")
        }
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController
{
    func GotoScreen(){
        let screen = self.storyboard?.instantiateViewController(withIdentifier: "IsLogin")
        if(screen != nil){
            self.present(screen!, animated: true, completion: nil)
        }
    }
}
