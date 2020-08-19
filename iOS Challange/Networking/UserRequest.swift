//
//  UserRequest.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/16/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import Foundation
import Moya

public enum UserRequest {
  case userList
}

extension UserRequest: TargetType {
  public var baseURL: URL {
    return URL(string: "https://jsonplaceholder.typicode.com")!
  }

  public var path: String {
    switch self {
    case .userList: return "/users"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .userList: return .get
    }
  }

  public var sampleData: Data {
    return Data()
  }

 public var task: Task {
    
    switch self {
    case .userList:
      return .requestParameters(
        parameters: ["" : ""],
        encoding: URLEncoding.default)
    }
  }

  public var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }

  public var validationType: ValidationType {
    return .successCodes
  }
}
