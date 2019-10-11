//
//  ScreenChatViewController.swift
//  SimpleChat
//
//  Created by NguyenCuong on 1/18/19.
//  Copyright © 2019 NguyenCuong. All rights reserved.
//

import UIKit
import Firebase
class ScreenChatViewController: UIViewController {
    
    
    @IBOutlet weak var constraintViewText: NSLayoutConstraint!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var tblMessage: UITableView!
    
    var TableName: DatabaseReference!
    var arrIDChat: Array<String> = Array<String>()
    var arrTxtChat: Array<String> = Array<String>()
    var arrUserChar: Array<User> = Array<User>()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMessage.dataSource = self
        tblMessage.delegate = self
        
        showHideKeyboard()
        arrIDChat.append(currentUser.Id)
        arrIDChat.append(SelectedFriend.Id)
        arrIDChat.sort()
        let Key: String = arrIDChat[0] + arrIDChat[1]
        TableName = ref.child("Chat").child(Key)
        
        
        // Listen for new comments in the Firebase database
        TableName.observe(.childAdded, with: { (snapshot) in
            let PostDict = snapshot.value as? [String: AnyObject]
            if(PostDict != nil){
                if((PostDict?["id"] as! String) == currentUser.Id){
                    self.arrUserChar.append(currentUser)
                }
                else{
                    self.arrUserChar.append(SelectedFriend)
                }
                
                self.arrTxtChat.append(PostDict?["message"] as! String)
                self.tblMessage.reloadData()
                //print("\(self.arrTxtChat)-------------")
                //print("\(self.arrUserChar)-----------")
            }
        })
    }
    
    @IBAction func btnASend(_ sender: Any) {
        let mess: Dictionary<String, String> = ["id": currentUser.Id, "message": txtMessage.text!]
        TableName.childByAutoId().setValue(mess)
        txtMessage.text = ""
        
        if(arrTxtChat.count == 0){
            AddListChat(sender: currentUser, receiver: SelectedFriend)
            AddListChat(sender: SelectedFriend, receiver: currentUser)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func showHideKeyboard()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(ScreenChatViewController.showKey(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScreenChatViewController.hideKey(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func showKey(_ notification: Notification)
    {
        let s:NSValue = (notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rect:CGRect = s.cgRectValue
        self.constraintViewText.constant = rect.size.height
        UIView.animate(withDuration: 1) { () -> Void in
            self.view.layoutIfNeeded()
            
            
        }
    }
    
    
    @objc func hideKey(_ notification: Notification)
    {
        self.constraintViewText.constant = 0
        UIView.animate(withDuration: 1) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    func AddListChat(sender: User, receiver: User){
        let TableName2 = ref.child("ListChat").child(sender.Id).child(receiver.Id)
        let user: Dictionary<String, String> = ["email": receiver.Email, "fullname": receiver.FullName, "linkAvatar": receiver.LinkAvatar]
        TableName2.setValue(user)
    }
}
extension ScreenChatViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTxtChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(currentUser.Id == arrUserChar[indexPath.row].Id){
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! MyChatTableViewCell
            cell.lblMessage.text = arrTxtChat[indexPath.row]
            cell.imgAvatar.image = currentUser.Avatar
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! FriendChatTableViewCell
            cell.lblMessage.text = arrTxtChat[indexPath.row]
            cell.imgAvatar.image = SelectedFriend.Avatar
            cell.imgAvatar.RoundImage()
            return cell
        }
    }
    
    
}
