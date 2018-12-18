//
//  SearchTableViewController.swift
//  API Projects
//
//  Created by Gabriel Blaine Palmer on 12/12/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    enum SearchType {
        case randomUser
        case representative
        case nobelPrize
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentSearchType: SearchType = .randomUser

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        navigationItem.title = "Random User"
    }

    //========================================
    // MARK: - Table view data source
    //========================================

    override func numberOfSections(in tableView: UITableView) -> Int {
        switch currentSearchType {
        case .randomUser:
            return 1
        case .representative:
            if Representative.loadedSens.count == 0 && Representative.loadedReps.count == 0 {
                return 0
            }
            return 2
        case .nobelPrize:
            return NobelPrize.loadedPrizes.count
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentSearchType {
        case .randomUser:
            return RandomUser.loadedUsers.count
        case .representative:
            return section == 0 ? Representative.loadedSens.count : Representative.loadedReps.count
        case .nobelPrize:
            return NobelPrize.loadedPrizes[section].laureates.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch currentSearchType {
        case .randomUser:
            return nil
            
        case .representative:
            if section == 0 {
                return "Senators"
            } else {
                return "House Representatives"
            }
            
        case .nobelPrize:
            return NobelPrize.loadedPrizes[section].category.capitalized
        }
    }
    
    
    fileprivate func configureUserCell(cell: RandomUserTableViewCell, user: RandomUser) {
        
        URLSession.shared.dataTask(with: URL(string: user.pictureURL)!) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    cell.pictureView.image = image
                }
                
            } else {
                print("Failed to retrieve image")
                print("ERROR: \(error!)")
            }
            }.resume()
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch currentSearchType {
        case .randomUser:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! RandomUserTableViewCell
            let user = RandomUser.loadedUsers[indexPath.row]
            cell.nameLabel.text = user.firstName + " " + user.lastName
            configureUserCell(cell: cell, user: user)
            return cell
            
        case .representative:
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "repCell", for: indexPath) as! RepresentativeTableViewCell
            let rep = indexPath.section == 0 ? Representative.loadedSens[indexPath.row] : Representative.loadedReps[indexPath.row]
            
            cell.nameLabel.text = "Name: " + rep.name
            cell.stateLabel.text = "State: " + rep.state
            cell.partyLabel.text = "Party: " + rep.party
            
            if indexPath.section == 0 {
                cell.districtLabel.isHidden = true
            } else {
                cell.districtLabel.isHidden = false
                if rep.district.isEmpty {
                    cell.districtLabel.text = "District: none"
                } else {
                    cell.districtLabel.text = "District: " + rep.district
                }
            }
            
            return cell
            
        case .nobelPrize:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "laureateCell", for: indexPath) as! LaureateTableViewCell
            let laureate = NobelPrize.loadedPrizes[indexPath.section].laureates[indexPath.row]
            cell.nameLabel.text = laureate.firstName + " " + laureate.lastName
            cell.motivationTextView.text = laureate.motivation
            return cell
            
        }
    }
    
    
    //========================================
    // MARK: - Search Bar Delegate
    //========================================
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text, !searchTerm.isEmpty {
            switch currentSearchType {
                
            case .randomUser:
                guard let amount = Int(searchTerm) else { return }
                guard amount <= 100 && amount > 0 else { return }
                NetworkController.loadRandomUsers(amount: searchTerm) {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            case .representative:
                
                //check if search term might be a zipcode
                if Int(searchTerm) != nil {
                    guard searchTerm.count == 5 else {
                        clearTable()
                        return
                    }
                    
                    NetworkController.loadRepsWith(zipcode: searchTerm) {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    
                //check if search term was already in postal code format
                } else if searchTerm.count == 2 {
                    
                    //updates search bar to full state name
                    if let state = Representative.postalCodes.allKeys(forValue: searchTerm).first {
                        searchBar.text = state.capitalized
                    }
                    
                        NetworkController.loadRepsWith(state: searchTerm.uppercased()) {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                        
                //check if search term was a state and get postal code
                } else if let abr = Representative.postalCodes[searchTerm.lowercased()] {
                    
                    NetworkController.loadRepsWith(state: abr) {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    
                } else {
                    clearTable()
                }
                
            case .nobelPrize:
                guard Int(searchTerm) != nil, searchTerm.count == 4 else {
                    clearTable()
                    return
                }
                
                NetworkController.loadNobelPrizesFrom(year: searchTerm) {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        switch currentSearchType {
        case .randomUser, .nobelPrize:
            let invalidCharacters = CharacterSet(charactersIn: "0123456789\n").inverted
            return text.rangeOfCharacter(from: invalidCharacters) == nil
        case .representative:
            return true
        }
    }
    
    
    //========================================
    // MARK: - Actions
    //========================================
    
   
    @IBAction func searchTypeButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(
            title: "Search For...",
            message: nil,
            preferredStyle: .actionSheet)
        
        if currentSearchType != .randomUser {
            let userAction = UIAlertAction(
                title: "Random User",
                style: .default) { (_) in
                    self.currentSearchType = .randomUser
                    self.searchBar.text = ""
                    self.navigationItem.title = "Random User"
                    self.searchBar.placeholder = "Amount"
                    self.clearTable()
            }
            alertController.addAction(userAction)
        }
        
        if currentSearchType != .representative {
            let representativeAction = UIAlertAction(
                title: "Local Representatives",
                style: .default) { (_) in
                    self.currentSearchType = .representative
                    self.searchBar.text = ""
                    self.navigationItem.title = "Local Representatives"
                    self.searchBar.placeholder = "Zipcode or State"
                    self.clearTable()
            }
            alertController.addAction(representativeAction)
        }
        
        if currentSearchType != .nobelPrize {
            let nobelAction = UIAlertAction(
                title: "Nobel Prizes",
                style: .default) { (_) in
                    self.currentSearchType = .nobelPrize
                    self.searchBar.text = ""
                    self.navigationItem.title = "Nobel Prizes"
                    self.searchBar.placeholder = "Year"
                    self.clearTable()
            }
            alertController.addAction(nobelAction)
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
    }
    
    
    //========================================
    // MARK: - Custom Functions
    //========================================
    
    
    fileprivate func clearTable() {
        RandomUser.loadedUsers.removeAll()
        Representative.loadedReps.removeAll()
        Representative.loadedSens.removeAll()
        NobelPrize.loadedPrizes.removeAll()
        
        tableView.reloadData()
    }
    
}
