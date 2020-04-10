//
//  UserDataSource.swift
//  T-Mobile
//
//  Created by Srinadh on 4/9/20.
//  Copyright © 2020 Srinadh. All rights reserved.
//

import Foundation

class  UserDataSource{
    var onErrorHandling : ((String) -> Void)?
    var completion: (([UserItem]) -> Void)?
    private let kUserSearchURL = "https://api.github.com/search/users?q="
    func fetchUserList(name: String){
        APIClient.shared.fetchData(urlStr: kUserSearchURL+name) { [weak self](result) in
            switch result{
            case .failure(let msg) :
                self?.onErrorHandling?(msg.localizedDescription)
            case .success(let data) :
                do{
                    let usersList = try JSONDecoder().decode(UserModel.self, from: data)
                    if let msg = usersList.message{
                        self?.onErrorHandling?(msg)
                    }
                    else if let items = usersList.items{
                        self?.completion?(items)
                    }
                }
                catch{
                    self?.onErrorHandling?("Error while parsing json data")
                }
                
            }
        }
    }
}
