//
//  UserViewController.swift
//  GitHubAPIDemo
//
//  Created by Bhagyashree Haresh Khatri on 22/08/2019.
//  Copyright © 2019 Bhagyashree Haresh Khatri. All rights reserved.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var loginNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
   
}

class UserViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var userListView: UIView!
    @IBOutlet weak var searchView: UIVisualEffectView!
    let presenter = UserPresenter(userService: UserService())
    var usersList = [UsersModel]()
    var userDetails  : UserDetailModel?
    var userName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emptyTextfields(textField: searchTextField)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBActions
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        searchView.isHidden = false
        userListView.isHidden = true
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        searchView.isHidden = true
        userListView.isHidden = false
    }
    
    
    @IBAction func allUsersTapped(_ sender: UIBarButtonItem) {
        presenter.getUsersList()
    }
    
    //MARK: - Custom Functions
    func config(){
        tableView?.dataSource = self
        tableView?.delegate = self
        searchTextField?.delegate = self
        activityIndicator?.hidesWhenStopped = true
        searchView.isHidden = true
        presenter.attachView(view: self)
        presenter.getUsersList()
    }
    
    func validations(){
        if userName.isEmpty {
            showError(errorMessage: "Please enter user name!!")
        }
        else{
            presenter.searchUsersList(userName:userName)
        }
    }
    
    func emptyTextfields (textField: UITextField){
        textField.text = ""
    }
}

//MARK: - UITableView Delegates & DataSoruce
extension UserViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        let userViewData = usersList[indexPath.row]
        cell.loginNameLabel?.text = userViewData.login
        if let url = userViewData.avatar_url {
            cell.avatarImageView.kf.setImage(with: URL(string:url))
        }
        else{
            cell.avatarImageView.image = UIImage(named: "defaultUserImg")
        }
        cell.avatarImageView.setRounded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.getUserDetails(userName:usersList[indexPath.row].login!)
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

//MARK: - Protocols Implementation
extension UserViewController: UserView {
    func setUsers(users: [UsersModel]) {
        usersList = users
        userListView.isHidden = false
        searchView.isHidden = true
        tableView?.reloadData()
    }
    
    func setEmptyUsers() {
        tableView?.isHidden = true
    }
    
    func setUserDetails(userDetails: UserDetailModel) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: UserDetailViewController = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        controller.userDetails = userDetails
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func startLoading() {
        // Show your loader
        activityIndicator?.startAnimating()
    }
    
    func finishLoading() {
        // Dismiss your loader
        activityIndicator?.stopAnimating()
    }
    
    func showError(errorMessage: String){
        Helper.showToast(controller: self, message: errorMessage)
    }
    
}

//MARK: - UITextfield Delegate
extension UserViewController: UITextFieldDelegate {
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let username = textField.text{
            userName = username
        }
        validations()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UIImageView
extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
}
