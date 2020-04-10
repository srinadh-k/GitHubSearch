//
//  UserRepModel.swift
//  T-Mobile
//
//  Created by Srinadh on 4/10/20.
//  Copyright © 2020 Srinadh. All rights reserved.
//

import Foundation
struct  UserRepModel : Decodable {
       var totalRep : Int?
       var items: [UserRepItem]?
       var message: String?
       private enum CodingKeys: String, CodingKey {
               case totalRep = "total_count"
               case items
               case message
       }
}
struct UserRepItem : Decodable{
    var name: String
    var forks: Int
    var start : Int
    var repUrl : String
    private enum CodingKeys: String, CodingKey {
            case name
            case forks
            case start = "stargazers_count"
            case repUrl = "html_url"
    }
}
