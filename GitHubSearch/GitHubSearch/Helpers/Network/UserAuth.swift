//
//  User.swift
//  T-Mobile
//
//  Created by Srinadh on 4/10/20.
//  Copyright © 2020 Srinadh. All rights reserved.
//

import UIKit
class UserAuth : NSObject  {
    static let shared = UserAuth()
    private override init() {}
    var userEmail: String?
    var userPassword: String?

}
