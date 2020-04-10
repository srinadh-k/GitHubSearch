//
//  UserDetailsDataSource.swift
//  T-Mobile
//
//  Created by Srinadh on 4/10/20.
//  Copyright © 2020 Srinadh. All rights reserved.
//

import Foundation
class  UserDetailsDataSource{
    var onErrorHandling : ((String) -> Void)?
    var userDetailsCompletion: ((UserDetailsModel) -> Void)?
    var userRepCompletion: ((UserRepModel) -> Void)?
    func fetchUserDetails(url: String){
        APIClient.shared.fetchData(urlStr: url) { [weak self](result) in
            switch result{
            case .failure(let msg) :
                self?.onErrorHandling?(msg.localizedDescription)
            case .success(let data) :
                do{
                    let userObj = try JSONDecoder().decode(UserDetailsModel.self, from: data)
                    if let msg = userObj.message{
                        self?.onErrorHandling?(msg)
                    }
                    else if let _ = userObj.login{
                        self?.userDetailsCompletion?(userObj)
                    }
                }
                catch{
                    self?.onErrorHandling?("Error while parsing json data")
                }
            }
        }
    }
    func searchRepo(search: String, name: String){
        let kUserSearchURL = "https://api.github.com/search/repositories?q=\(search)+user:\(name)+fork:true"

        APIClient.shared.fetchData(urlStr: kUserSearchURL) { [weak self](result) in
            switch result{
            case .failure(let msg) :
                self?.onErrorHandling?(msg.localizedDescription)
            case .success(let data) :
                do{
                    let repObj = try JSONDecoder().decode(UserRepModel.self, from: data)
                    if let msg = repObj.message{
                        self?.onErrorHandling?(msg)
                    }
                    else if let _ = repObj.totalRep{
                        self?.userRepCompletion?(repObj)
                    }
                    
                }
                catch{
                    self?.onErrorHandling?("Error while parsing json data")
                }
            }
        }
    }
}
