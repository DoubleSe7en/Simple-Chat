//
//  ScreenListChatViewController.swift
//  SimpleChat
//
//  Created by NguyenCuong on 1/18/19.
//  Copyright © 2019 NguyenCuong. All rights reserved.
//

import UIKit
import Firebase

let ref = Database.database().reference()
var currentUser: User!
class ScreenListChatViewController: UIViewController {
    
    var ListFriend: Array<User> = Array<User>()
    var arrUserChat: Array<User> = Array<User>()
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var tbtListChat: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnMenu.toggleMenu(screen: self)
        
        tbtListChat.dataSource = self
        tbtListChat.delegate = self
        
        let user = Auth.auth().currentUser
        if let user = user {
             //The user's ID, unique to the Firebase project.
             //Do NOT use this value to authenticate with your backend server,
             //if you have one. Use getTokenWithCompletion:completion: instead.
            let uid = user.uid
            let name = user.displayName
            let email = user.email
            let photoURL = user.photoURL
            // ...
            currentUser = User(id: uid, email: email!, fullName: name!, linkAvatar: (photoURL?.relativeString)!)
            let TableName = ref.child("ListFriend")
            let UserID = TableName.child(currentUser.Id)
            let user: Dictionary<String, String> = ["email": currentUser.Email, "fullname": currentUser.FullName, "linkAvatar": currentUser.LinkAvatar]
            UserID.setValue(user)
            
            let url: URL = URL(string: currentUser.LinkAvatar)!
            do{
                let data: Data = try Data(contentsOf: url)
                currentUser.Avatar = UIImage(data: data)
            }
            catch{
                
            }
            
            let TableName2 = ref.child("ListChat").child(currentUser.Id)
            // Listen for new comments in the Firebase database
            TableName2.observe(.childAdded, with: { (snapshot) in
                let PostDict = snapshot.value as? [String: AnyObject]
                if(PostDict != nil){
                    let email: String = PostDict?["email"] as! String
                    let fullname: String = PostDict?["fullname"] as! String
                    let linkAvatar: String = PostDict?["linkAvatar"] as! String
                    let user: User = User(id: snapshot.key, email: email, fullName: fullname, linkAvatar: linkAvatar)
                    self.arrUserChat.append(user)
                    self.tbtListChat.reloadData()
                }
            })
        }
        else{
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLogOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    
}
extension ScreenListChatViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListChatTableViewCell
        cell.lblName.text = arrUserChat[indexPath.row].FullName
        cell.imgAvatar.LoadAvatar(urlString: arrUserChat[indexPath.row].LinkAvatar)
        cell.imgAvatar.RoundImage()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedFriend = arrUserChat[indexPath.row]
        let url: URL = URL(string: SelectedFriend.LinkAvatar)!
        do{
            let data: Data = try Data(contentsOf: url)
            SelectedFriend.Avatar = UIImage(data: data)
        }
        catch{
            print("Error load avatar")
        }
        
    }
    
}
