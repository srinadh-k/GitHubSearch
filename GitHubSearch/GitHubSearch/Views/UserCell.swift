//
//  UserCell.swift
//  T-Mobile
//
//  Created by Srinadh on 4/9/20.
//  Copyright © 2020 Srinadh. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var userPicImgView: UIImageView?
    @IBOutlet weak var userNameLbl: UILabel?
    @IBOutlet weak var userRepCountLbl: UILabel?
    @IBOutlet weak var userBtn: UIButton?
    var btnClickHandler : ((UIButton) -> Void)?
    var userDetails : ((UILabel, UserDetailsModel) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func prepareDisplay(user: UserItem){
        userPicImgView?.loadImage(fromURL: user.avatar)
        userNameLbl?.text = user.login
        //userRepCountLbl?.text = ""
        if let details = user.userDetail, let count = details.publicRep{
            userRepCountLbl?.text = "Repo#: \(count)"
        }
        else{
            userRepCountLbl?.text = "..."
            userRepCountLbl?.loadPublicRepCount(fromURL: user.userUrl, completion: userDetails)
        }
        //
        
    }
    @IBAction func onClick(btn: UIButton){
        if let btnHandler = btnClickHandler{
            btnHandler(btn)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
