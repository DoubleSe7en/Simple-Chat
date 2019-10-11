//
//  ScreenRegisterViewController.swift
//  SimpleChat
//
//  Created by NguyenCuong on 1/18/19.
//  Copyright © 2019 NguyenCuong. All rights reserved.
//

import UIKit
import Firebase

let storage = Storage.storage()
let storageRef = storage.reference(forURL: "gs://simplechat-80272.appspot.com")
class ScreenRegisterViewController: UIViewController {

    @IBOutlet weak var uvRegister: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPWD: UITextField!
    @IBOutlet weak var txtCPWD: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    var imgData: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRegister.skin(b: false)
        btnLogin.skin(b: false)
       
        imgAvatar.layer.cornerRadius = 25
        imgAvatar.clipsToBounds = true
        uvRegister.Login()
        imgData = UIImagePNGRepresentation(UIImage(named: "camera")!)
    }

    
    
    @IBAction func btnARegister(_ sender: Any) {
        let email: String = txtEmail.text!
        let password: String = txtPWD.text!
        let ConfirmPassword: String = txtCPWD.text!
        let btnOK: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        //Loi nhap mat khau < 6 ky tu
        if(password.count < 6){
            let alert:UIAlertController = UIAlertController(title: "Notification", message: "The password you entered is too short", preferredStyle: .alert)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //Loi xac nhan mat khau
        if(password != ConfirmPassword){
            let alert:UIAlertController = UIAlertController(title: "Notification", message: "Confirm password is not correct", preferredStyle: .alert)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPWD.text!) { (user, error) in
            // ...
            
            
             if (error != nil) {
                //Loi da user da ton tai
                if(error?.code  == 17007){
                    let alert:UIAlertController = UIAlertController(title: "Notification", message: "The " + email + " you entered already exists", preferredStyle: .alert)
                    alert.addAction(btnOK)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                //Loi nhap email khong hop le
                if(error?.code  == 17008){
                   // activity.stopAnimating()
                   // alertActivity.dismiss(animated: true, completion: nil)
                    
                    let alert:UIAlertController = UIAlertController(title: "Notification", message: "The " + email + " you entered is not vaild", preferredStyle: .alert)
                    alert.addAction(btnOK)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
             else{
                //Thong bao dang ky thanh cong
                let alert:UIAlertController = UIAlertController(title: "Notification", message: "Registration success!!!" , preferredStyle: .alert)
                alert.addAction(btnOK)
                self.present(alert, animated: true, completion: nil)
            }
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if(error != nil){
                    //print("Loixxxxxxxxxxx")
                    return
                }
            }
            // Create a reference to the file you want to upload
            let avatarRef = storageRef.child("images/\(email).jpg")
            
            // Upload the file to the path "images/rivers.jpg"
            let uploadTask = avatarRef.putData(self.imgData, metadata: nil) { (metadata, error) in
                if (metadata == nil) {
                    //print("Loi up hinh")
                    return
                }
                avatarRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                        }
                    let user = Auth.auth().currentUser
                    if let user = user{
                        let changeRequest = user.createProfileChangeRequest()
                        if(self.txtFullName.text == nil){
                            changeRequest.displayName = self.txtEmail.text!
                        }
                        else{
                            changeRequest.displayName = self.txtFullName.text!
                        }
                        changeRequest.photoURL = downloadURL
                        changeRequest.commitChanges { (error) in
                                // ...
                                if(error == nil){
                                    //Chuyen qua list chat
                                    self.GotoScreen()
                                    
                                }
                                else{
                                    print("Loi---------")
                                }
                        }
                    }
                }
            }
            uploadTask.resume()
            
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapAvatar(_ sender: UITapGestureRecognizer) {
        let btnOK: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        let alert:UIAlertController = UIAlertController(title: "Notification", message: "Choose your picture", preferredStyle: .alert)
        
        let btnPhoto: UIAlertAction = UIAlertAction(title: "Photo", style: UIAlertActionStyle.default) { (UIAlertAction) in
            let imgPicker = UIImagePickerController()
            imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imgPicker.delegate = self
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
        }
        
        let btnCamera: UIAlertAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) {  (UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imgPicker = UIImagePickerController()
                imgPicker.sourceType = UIImagePickerControllerSourceType.camera
                imgPicker.delegate = self
                imgPicker.allowsEditing = false
                self.present(imgPicker, animated: true, completion: nil)
            }
            else{
                
                let alert2:UIAlertController = UIAlertController(title: "Notification", message: "Your phone is not camera", preferredStyle: .alert)
                alert2.addAction(btnOK)
                self.present(alert2, animated: true, completion: nil)
            
            }
        }
    
        alert.addAction(btnPhoto)
        alert.addAction(btnCamera)
        self.present(alert, animated: true, completion: nil)
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

extension ScreenRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chooseImg = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imgValue = max(chooseImg.size.width, chooseImg.size.height)
        if imgValue > 3000{
            imgData = UIImageJPEGRepresentation(chooseImg, 0.1)!
        }
        else if imgValue > 2000{
            imgData = UIImageJPEGRepresentation(chooseImg, 0.3)!
        }
        else{
            imgData = UIImagePNGRepresentation(chooseImg)!
        }
        imgAvatar.image = UIImage(data: imgData)
        
        dismiss(animated: true, completion: nil)
    }
}





