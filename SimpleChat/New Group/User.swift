//
//  User.swift
//  SimpleChat
//
//  Created by NguyenCuong on 1/19/19.
//  Copyright © 2019 NguyenCuong. All rights reserved.
//

import Foundation
class User{
    let Id: String!
    let Email: String!
    let FullName: String!
    let LinkAvatar: String!
    var Avatar: UIImage!
    init() {
        Id = ""
        Email = ""
        FullName = ""
        LinkAvatar = ""
        Avatar = UIImage(named: "personicon")!
    }
    init(id: String, email: String, fullName: String, linkAvatar: String){
        self.Id = id
        self.Email = email
        self.FullName = fullName
        self.LinkAvatar = linkAvatar
        self.Avatar = UIImage(named: "personicon")!
    }
}
