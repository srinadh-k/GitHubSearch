//
//  UsersVC.swift
//  T-Mobile
//
//  Created by Srinadh on 4/9/20.
//  Copyright © 2020 Srinadh. All rights reserved.
//

import UIKit

class UsersVC: UITableViewController {
    private var searchResults = [UserItem]() {
        didSet {
            if searchResults.isEmpty {
                self.backgroundViewLabel.text = kNoUSers
            }
            if let txt = searchController.searchBar.text, txt.isEmpty{
                self.backgroundViewLabel.text = ""
            }
            tableView.reloadData()
        }
    }
    private let searchController = UISearchController(searchResultsController: nil)
    private let datasource = UserDataSource()
    private var previousRun = Date()
    private let minInterval : TimeInterval = 2
    private let kSearchUSers = "Search GitHub Users"
    private let kNoUSers = "No Users Found"
    private let kUserDetailsSegue = "UserDetailsSegue"
    private let kUserCellIdentifier = "UserCell"

    private let backgroundViewLabel = UILabel(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableViewBackgroundView()
        datasource.onErrorHandling = { [weak self] errorMsg in
            self?.backgroundViewLabel.text = errorMsg
        }
        datasource.completion = { [weak self] users in
            self?.backgroundViewLabel.text = ""
            
            if let loginName = users.first?.login{
                if let txt = self?.searchController.searchBar.text, let _ = loginName.range(of: txt, options: .caseInsensitive){
                
                    self?.searchResults = users
                }
            }
            else{
                self?.searchResults = users
            }
        }
    }
    private func setupSearchBar(){
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = kSearchUSers
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    private func setupTableViewBackgroundView() {
           backgroundViewLabel.textColor = .darkGray
           backgroundViewLabel.numberOfLines = 0
           backgroundViewLabel.text = kSearchUSers
           backgroundViewLabel.textAlignment = NSTextAlignment.center
           backgroundViewLabel.font.withSize(20)
           tableView.backgroundView = backgroundViewLabel
       }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kUserCellIdentifier,
                                                 for: indexPath) as? UserCell
        if let cell = cell{
            cell.userBtn?.tag = indexPath.row
            cell.userRepCountLbl?.tag = indexPath.row
            cell.prepareDisplay(user: searchResults[indexPath.row])
            cell.btnClickHandler = { [weak self]btn in
                guard let strongSelf = self else { return }
                let obj = strongSelf.searchResults[btn.tag]
                strongSelf.performSegue(withIdentifier: strongSelf.kUserDetailsSegue, sender: obj)
            }
            cell.userDetails = { [weak self] (lbl, details) in
                if self?.searchResults.indices.contains(lbl.tag) ?? false {
                    self?.searchResults[lbl.tag].userDetail = details
                }
            }
            return cell
        }
        
        return UITableViewCell()

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? UserDetailVC, let userObj = sender as? UserItem{
            detailsVC.userObj = userObj
        }
    }
}
extension UsersVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            searchResults = []
            return
        }
        self.backgroundViewLabel.text = ""
            datasource.fetchUserList(name: searchText)
            
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            backgroundViewLabel.text = ""
        
    }
}
