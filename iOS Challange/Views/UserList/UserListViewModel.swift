//
//  UserListViewModel.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/16/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserListViewModel {
    private let router = UserRouter()
    
    let userList: BehaviorRelay<User> = BehaviorRelay(value: [])
    let errorMessage: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func getUsers() {
        router.startUserListRequest { [weak self] (users, error) in
            guard users != nil else {
                self?.errorMessage.accept(error ?? "")
                return
            }
            self?.userList.accept(users!)
        }
    }
}
