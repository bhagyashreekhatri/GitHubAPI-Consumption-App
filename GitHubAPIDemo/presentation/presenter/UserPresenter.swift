//
//  UserView.swift
//  GitHubAPIDemo
//
//  Created by Bhagyashree Haresh Khatri on 22/08/2019.
//  Copyright © 2019 Bhagyashree Haresh Khatri. All rights reserved.
//

import Foundation

protocol UserView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setUsers(users: [UsersModel])
    func setUserDetails(userDetails: UserDetailModel)
    func setEmptyUsers()
}

class UserPresenter {
    private let userService:UserService
    weak private var userView : UserView?
    
    init(userService:UserService) {
        self.userService = userService
    }
    
    func attachView(view:UserView) {
        userView = view
    }
    
    func detachView() {
        userView = nil
    }
    
    func getUsersList() {
        self.userView?.startLoading()
        userService.callAPIGetUsers(
            onSuccess: { (users) in
                self.userView?.finishLoading()
                if(users.count == 0){
                   self.userView?.setEmptyUsers()
                }
                else{
                     self.userView?.setUsers(users: users)
                }
            },
            onFailure: { (errorMessage) in
                self.userView?.finishLoading()
            }
        )
    }
    
    func getUserDetails(userName:String) {
        self.userView?.startLoading()
        userService.callAPIGetUserDetail(userName:userName,
            onSuccess: { (userDetailsResponse) in
                self.userView?.finishLoading()
                self.userView?.setUserDetails(userDetails: userDetailsResponse)
        },
            onFailure: { (errorMessage) in
                self.userView?.finishLoading()
        }
        )
    }
}
