//
//  UserDetailsCell.swift
//  T-Mobile
//
//  Created by Srinadh on 4/9/20.
//  Copyright © 2020 Srinadh. All rights reserved.
//

import UIKit

class UserDetailsCell: UITableViewCell {

    @IBOutlet weak var userPicImgView: UIImageView?
     @IBOutlet weak var userNameLbl: UILabel?
     @IBOutlet weak var emailLbl: UILabel?
     @IBOutlet weak var locationLbl: UILabel?
     @IBOutlet weak var followersLbl: UILabel?
     @IBOutlet weak var followingLbl: UILabel?
     @IBOutlet weak var joinLbl: UILabel?
     @IBOutlet weak var searchBarOutlet: UISearchBar?
     @IBOutlet weak var bioLBl: UILabel?

    @IBOutlet weak var repoNameLbl: UILabel?
    @IBOutlet weak var forksLbl: UILabel?
    @IBOutlet weak var startsLbl: UILabel?

    private let kUserName = "User Name: "
    private let kEmail = "Email: "
    private let kLocation = "Location: "
    private let kJoinDate = "Join Date: "
    private let kFollowers = "Followers: "
    private let kFollowings = "Followings: "
    private let kBiography = "Biography: "
    private let kNA = "N/A"

    private let kForks = " Forks"
    private let kStars = " Starts"

    func prepareUserBioDisplay(user: UserItem){
        userPicImgView?.loadImage(fromURL: user.avatar)
        userNameLbl?.colorString(text: kUserName + user.login, coloredText: kUserName)
        joinLbl?.colorString(text: kJoinDate + (user.userDetail?.joinDate?.displayDate() ?? kNA), coloredText: kJoinDate)
        emailLbl?.colorString(text: kEmail + (user.userDetail?.email ?? kNA), coloredText: kEmail)
        locationLbl?.colorString(text: kLocation + (user.userDetail?.location ?? kNA), coloredText: kLocation)
        followersLbl?.colorString(text: kFollowers + (user.userDetail?.followers?.description  ?? 0.description), coloredText: kFollowers)
        followingLbl?.colorString(text: kFollowings + (user.userDetail?.following?.description ?? 0.description), coloredText: kFollowings)
        bioLBl?.colorString(text: kBiography + (user.userDetail?.bio ?? kNA), coloredText: kBiography)

        
    }
    func preapreRepisoryDisplay(rep: UserRepItem){
        repoNameLbl?.text = rep.name
        forksLbl?.text = rep.forks.description + kForks
        startsLbl?.text = rep.start.description + kStars
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
