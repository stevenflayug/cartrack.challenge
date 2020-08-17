//
//  UserListTableViewController.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/16/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserListTableViewController: UITableViewController {
    let viewModel = UserListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getUsers()
        setupTableView()
        setupObservables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 60.0
        tableView.separatorStyle = .none
        tableView.delegate = nil
        tableView.dataSource = nil
        
        // Register Cell
        self.tableView.register(UINib(nibName: "UserTableViewCell", bundle: .main), forCellReuseIdentifier: "usercell")
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "System Bold", size: 22)
        titleLabel.text = "User List"
        titleLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 34)
        navigationItem.titleView = titleLabel
        
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.setStatusBar(backgroundColor: .userListLightBlue)
        navigationController?.navigationBar.backgroundColor = .userListLightBlue
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupObservables() {
        viewModel.userList.asObservable().bind(to: tableView.rx.items(cellIdentifier: "usercell", cellType: UserTableViewCell.self)) {
            index, item, cell in
            cell.setupCell(username: item.username, name: item.name)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard self == self else { return }
            let userDetailsVC = UserDetailsTableViewController()
            userDetailsVC.user.accept(self!.viewModel.userList.value[indexPath.row])
            self?.navigationController?.pushViewController(userDetailsVC, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.userList.asObservable().subscribe(onNext: { [unowned self] (_) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userList.value.count
    }
    
    func setupUserCell(_ indexPath: IndexPath, user: UserData) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usercell", for: indexPath) as! UserTableViewCell
        cell.selectionStyle = .none
        cell.setupCell(username: user.username, name: user.name)
        cell.selectionStyle = .none
        return cell
    }
}
