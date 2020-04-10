//
//  UserDetailVC.swift
//  T-Mobile
//
//  Created by Srinadh on 4/9/20.
//  Copyright © 2020 Srinadh. All rights reserved.
//

import UIKit

class UserDetailVC: UITableViewController {
    var userObj : UserItem?
    private var searchResults = [UserRepItem]() {
        didSet {
            if searchResults.isEmpty{
                self.backgroundViewLabel.text = kNoRepos
            }
            if let txt = searchBar?.text, txt.isEmpty{
                self.backgroundViewLabel.text = ""
            }
            let indexSet: IndexSet = [2]
            self.tableView.reloadSections(indexSet, with: .automatic)

        }
    }
    private let kSearchUSers = "Search Users Repositories"
    private let kNoRepos = "No Repositories Found"
    private let kBiographyCellIdentifier = "BiographyCell"
    private let kSearchBarCellIdentifier = "SearchBarCell"
    private let kRepositoryCellIdentifier = "RepositoryCell"
    
    private let backgroundViewLabel = UILabel(frame: .zero)
    private let datasource = UserDetailsDataSource()
    private var searchBar : UISearchBar?
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        setupTableViewBackgroundView()
        datasource.onErrorHandling = { [weak self] errorMsg in
            self?.backgroundViewLabel.text = errorMsg
        }
        datasource.userDetailsCompletion = { [weak self] users in
            self?.userObj?.userDetail = users
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            
        }
        datasource.userRepCompletion = { [weak self] userRep in
            self?.backgroundViewLabel.text = ""
            if let repName = userRep.items?.first?.name{
                if let txt = self?.searchBar?.text, let _ = repName.range(of: txt, options: .caseInsensitive){
                    self?.searchResults = userRep.items ?? []
                }
            }
            else{
                self?.searchResults = userRep.items ?? []
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if let userURL = userObj?.userUrl{
            
            datasource.fetchUserDetails(url: userURL)
        }
    }
    private func setupTableViewBackgroundView() {
              backgroundViewLabel.textColor = .darkGray
              backgroundViewLabel.numberOfLines = 0
              backgroundViewLabel.text = kSearchUSers
              backgroundViewLabel.textAlignment = NSTextAlignment.center
              backgroundViewLabel.font.withSize(20)
              tableView.backgroundView = backgroundViewLabel
          }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else if section == 1{
            return 1
        }
        else{
            return searchResults.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier:String = kBiographyCellIdentifier
        if indexPath.section == 0{
            cellIdentifier = kBiographyCellIdentifier
        }else if indexPath.section == 1{
            cellIdentifier = kSearchBarCellIdentifier
        }else if indexPath.section == 2{
            cellIdentifier = kRepositoryCellIdentifier
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath) as? UserDetailsCell
        if let cell = cell{
            cell.selectionStyle = .none
            switch indexPath.section {
            case 0:
                if let userobj = userObj{
                    cell.prepareUserBioDisplay(user: userobj)
                }
            case 1:
                searchBar = cell.searchBarOutlet
                break
            case 2:
                cell.selectionStyle = .blue
                cell.preapreRepisoryDisplay(rep: searchResults[indexPath.row])
            default:
                break
            }
            return cell
        }
        
        return UITableViewCell()
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            tableView.deselectRow(at: indexPath, animated: true)
            if let url = URL(string: searchResults[indexPath.row].repUrl){
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
        }
        
    }
    
}
extension UserDetailVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            searchResults = []
            return
        }
        if let userName = userObj?.login{
            self.backgroundViewLabel.text = ""
            datasource.searchRepo(search: searchText, name: userName)
        }
            
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            backgroundViewLabel.text = ""
        
    }
    
}
