//
//  ScreenListFriendViewController.swift
//  SimpleChat
//
//  Created by NguyenCuong on 1/18/19.
//  Copyright © 2019 NguyenCuong. All rights reserved.
//

import UIKit

var SelectedFriend: User!
class ScreenListFriendViewController: UIViewController {
    
    var ListFriend: Array<User> = Array<User>()
    
    @IBOutlet weak var tblListFriend: UITableView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnMenu.toggleMenu(screen: self)
        
        tblListFriend.dataSource = self
        tblListFriend.delegate = self
        
        // Listen for new comments in the Firebase database
        let TableName = ref.child("ListFriend")
        TableName.observe(.childAdded, with: { (snapshot) in
            let PostDict = snapshot.value as? [String: AnyObject]
            if(PostDict != nil){
                let email: String = PostDict?["email"] as! String
                let fullname: String = PostDict?["fullname"] as! String
                let linkAvatar: String = PostDict?["linkAvatar"] as! String
                let user: User = User(id: snapshot.key, email: email, fullName: fullname, linkAvatar: linkAvatar)
                //Khong  hien chinh minh`
                if(user.Id != currentUser.Id){
                    self.ListFriend.append(user)
                }
                self.tblListFriend.reloadData()
                
                }
        })
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension ScreenListFriendViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListFriend.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListFriendTableViewCell
        cell.lblName.text = ListFriend[indexPath.row].FullName
        cell.imgAvatar.LoadAvatar(urlString: ListFriend[indexPath.row].LinkAvatar)
        cell.imgAvatar.RoundImage()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedFriend = ListFriend[indexPath.row]
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
