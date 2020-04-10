//
//  UsersVC.swift
//  T-Mobile
//
//  Created by Srinadh on 4/9/20.
//  Copyright © 2020 Srinadh. All rights reserved.
//


import Foundation
enum RequestMethod: String {
    case Get = "GET"
    func value() -> String{
        return self.rawValue
    }
}

enum ServiceError: Error {
    case noInternetConnection
    case custom(String)
    case other
    
}
extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No inernet connection"
        case .other:
            return "Something went wrong, Please contact Admin"
        case .custom(let message):
            return message
        }
    }
}
extension ServiceError {
    init(json: [String:Any?]) {
        if let message =  json["message"] as? String {
            self = .custom(message)
        } else {
            self = .other
        }
    }
}
class APIClient: NSObject {
    
    public static let shared = APIClient()
    private override init(){}
    fileprivate var sessionTask : URLSessionDataTask?
    func fetchData(urlStr: String, completion: @escaping (Result<Data, ServiceError>) -> ())  {
        guard let url = URL(string: urlStr)else {
            completion(.failure(.custom("Invalid URL")))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod =  RequestMethod.Get.value()
        if let email = UserAuth.shared.userEmail, let password = UserAuth.shared.userPassword{
            let loginString = String(format: "%@:%@", email, password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        }
        else{
            completion(.failure(.custom("User Credentials missing")))
            return
        }

        if !Reachability()!.isReachable {
            completion(.failure(.noInternetConnection))
            return
        }
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
       /* if let task = sessionTask{
            task.cancel()
        }
        sessionTask = nil*/
        sessionTask = session.dataTask(with: request) { data, response, error in
           DispatchQueue.main.async{
                if let data = data {
                    completion(.success(data))
                }
                if let _error = error {
                    if let newerr = _error as NSError?, newerr.code == NSURLErrorCancelled{
                        return
                    }
                    completion(.failure(.custom("An error occured during request :" + _error.localizedDescription)))
                    return
                }
                
            }
            
        }
        sessionTask?.resume()
    }
    
}

