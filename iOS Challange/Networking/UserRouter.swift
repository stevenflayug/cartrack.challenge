//
//  UserRouter.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/16/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import Foundation
import UIKit
import Moya

class UserRouter {
    let provider = MoyaProvider<UserRequest>()
    
    public func startUserListRequest(completion: @escaping (_ users: User?, _ error: String?) -> Void) {
        provider.request(.userList) { result in
            switch result {
            case .success(let response):
                do {
                    print(try response.mapJSON())
                    if let results = try? response.map(User.self) {
                        print(results)
                        completion(results, nil)
                    }
                } catch {
                    completion(nil, "No users retrieved")
                    return
                }
            case .failure(let error):
                completion(nil, error.localizedDescription)
                return
            }
        }
    }
}
