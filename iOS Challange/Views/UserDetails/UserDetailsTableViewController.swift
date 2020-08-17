//
//  UserDetailsTableViewController.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/17/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserDetailsTableViewController: UITableViewController {
    private let viewModel = UserListViewModel()
    private let disposeBag = DisposeBag()
    var user: BehaviorRelay<UserData> = BehaviorRelay(value: UserData(id: 0, name: "", username: "", email: "", address: Address(street: "", suite: "", city: "", zipcode: "", geo: Geo(lat: "", lng: "")), phone: "", website: "", company: Company(name: "", catchPhrase: "", bs: "")))
    
    enum tableSections: Int {
        case name
        case contact
        case company
    }
    
    enum nameSectionRows: Int {
        case name
        case userName
    }
    
    enum contactSectionRows: Int {
        case email
        case address
        case phone
        case website
    }
    
    enum companySectionRows: Int {
        case name
        case catchPhrase
        case bs
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupObservables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    func setupObservables() {
        user.asObservable().subscribe(onNext: { [weak self] (_) in
            guard self == self else { return }
            self!.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 50.0
        tableView.separatorStyle = .none
        
        // Register Cell
        self.tableView.register(UINib(nibName: "UserDetailsTableViewCell", bundle: .main), forCellReuseIdentifier: "userdetailcell")
        self.tableView.register(UINib(nibName: "NameTableViewCell", bundle: .main), forCellReuseIdentifier: "namecell")
        self.tableView.register(UINib(nibName: "UserDetailsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "userdetailheader")
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "System Bold", size: 22)
        titleLabel.text = "User Details"
        titleLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 34)
        navigationItem.titleView = titleLabel
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.setStatusBar(backgroundColor: .userListLightBlue)
        navigationController?.navigationBar.backgroundColor = .userListLightBlue
        navigationController?.navigationBar.isTranslucent = true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableSections(rawValue: section) {
        case .name:
            return 2
        case .contact:
            return 4
        default:
            return 3
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupTableHeaderView(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableSections(rawValue: indexPath.section) {
        case .name:
            switch nameSectionRows(rawValue: indexPath.row) {
            case .name:
                return setupNameCell(indexPath, name: user.value.name)
            default:
                return setupDetailCell(indexPath, title: "Username", value: user.value.username)
            }
        case .contact:
            switch contactSectionRows(rawValue: indexPath.row) {
            case .email:
                return setupDetailCell(indexPath, title: "Email", value: user.value.email)
            case .address:
                let address = "\(user.value.address.suite), \(user.value.address.street), \(user.value.address.city) \(user.value.address.zipcode)"
                return setupDetailCell(indexPath, title: "Address", value: address)
            case .phone:
                return setupDetailCell(indexPath, title: "Phone", value: user.value.phone)
            default:
                return setupDetailCell(indexPath, title: "Website", value: user.value.website)
            }
        default:
            switch companySectionRows(rawValue: indexPath.row) {
            case .name:
                return setupDetailCell(indexPath, title: "Company Name", value: user.value.company.name)
            case .catchPhrase:
                return setupDetailCell(indexPath, title: "Catchphrase", value: user.value.company.catchPhrase)
            default:
                return setupDetailCell(indexPath, title: "Business Strategy", value: user.value.company.bs)
            }
        }
    }
    
    func setupNameCell(_ indexPath: IndexPath, name: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "namecell", for: indexPath) as! NameTableViewCell
        cell.setupCell(name: name)
        cell.selectionStyle = .none
        return cell
    }
    
    func setupDetailCell(_ indexPath: IndexPath, title: String, value: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userdetailcell", for: indexPath) as! UserDetailsTableViewCell
        cell.setupCell(title: title, value: value)
        cell.selectionStyle = .none
        return cell
    }
    
    func setupTableHeaderView(_ section: Int) -> UIView {
        let headerView = Bundle.main.loadNibNamed("UserDetailsHeaderView", owner: self, options: nil)?.last as! UserDetailsHeaderView
        switch tableSections(rawValue: section) {
        case .name:
            headerView.setupView(title: "")
        case .contact:
            headerView.setupView(title: "Contact Information")
        default:
            headerView.setupView(title: "Company Information")
        }
        return headerView
    }
}

