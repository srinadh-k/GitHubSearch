//
//  UserDetails.swift
//  T-Mobile
//
//  Created by Srinadh on 4/9/20.
//  Copyright © 2020 Srinadh. All rights reserved.
//

import Foundation
struct  UserDetailsModel : Decodable {
    
    var login : String?
    var id: Int?
    var avatar: String?
    var publicRep : Int?
    var email: String?
    var location: String?
    var joinDate: String?
    var followers: Int?
    var following: Int?
    var bio: String?
    var message: String?
    private enum CodingKeys: String, CodingKey {
            case login
            case id
            case avatar = "avatar_url"
            case publicRep = "public_repos"
            case email
            case location
            case joinDate = "created_at"
            case followers
            case following
            case bio
            case message
    }
}
