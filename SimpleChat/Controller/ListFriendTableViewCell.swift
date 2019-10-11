//
//  ListFriendTableViewCell.swift
//  SimpleChat
//
//  Created by NguyenCuong on 1/19/19.
//  Copyright © 2019 NguyenCuong. All rights reserved.
//

import UIKit

class ListFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
