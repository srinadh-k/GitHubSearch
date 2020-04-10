//
//  UserModel.swift
//  T-Mobile
//
//  Created by Srinadh on 4/9/20.
//  Copyright © 2020 Srinadh. All rights reserved.
//

import Foundation
struct UserModel : Decodable {
    var totalUsers : Int?
    var items: [UserItem]?
    var message: String?
    private enum CodingKeys: String, CodingKey {
            case totalUsers = "total_count"
            case items
            case message
    }
}
struct UserItem : Decodable{
    var login : String
    var id: Int
    var avatar: String
    var userUrl: String
    var userDetail: UserDetailsModel?
    private enum CodingKeys: String, CodingKey {
            case login
            case id
            case avatar = "avatar_url"
            case userUrl = "url"
            case userDetail

    }

}

