//
//  NetworkController.swift
//  API Projects
//
//  Created by Gabriel Blaine Palmer on 12/12/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import Foundation
import UIKit

class NetworkController {
    
    //========================================
    // MARK: - Base URLs
    //========================================
    
    static let zipAllRepURL = "https://whoismyrepresentative.com/getall_mems.php?output=json&zip="
    static let stateRepURL = "https://whoismyrepresentative.com/getall_reps_bystate.php?output=json&state="
    static let stateSenURL = "https://whoismyrepresentative.com/getall_sens_bystate.php?output=json&state="
    
    static let randomUserURL = "https://randomuser.me/api/?results="
    
    static let nobelPrizeURL = "http://api.nobelprize.org/v1/prize.json?year="
    
    //========================================
    // MARK: - Functions
    //========================================
    
    
    fileprivate static func fetchDataFrom(url: URL, completion: @escaping (Data?) -> Void) {
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("There was a problem fetching data")
                print(error as Any)
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            
            completion(data)
            
            
            }.resume()
    }
    
    
    fileprivate static func setReps(reps: [Representative]) {
        Representative.loadedReps.removeAll()
        Representative.loadedSens.removeAll()
        
        for rep in reps {
            if rep.website.contains("senate") {
                Representative.loadedSens.append(rep)
            } else {
                Representative.loadedReps.append(rep)
            }
        }
    }
    
    
    static func loadRepsWith(state: String, completion: @escaping () -> Void) {
        
        let repURL = URL(string: NetworkController.stateRepURL + state)!
        let senURL = URL(string: NetworkController.stateSenURL + state)!
        
        NetworkController.fetchDataFrom(url: repURL) { (repData) in
            
            if let repData = repData {
                NetworkController.fetchDataFrom(url: senURL, completion: { (senData) in
                    if let senData = senData {
                        
                        
                        let decoder = JSONDecoder()
                        var results: [Representative] = []
                        
                        do {
                            let repDictionary = try decoder.decode(IntermediateRep.self, from: repData)
                            let senDictionary = try decoder.decode(IntermediateRep.self, from: senData)
                            results = repDictionary.results
                            results += senDictionary.results
                            NetworkController.setReps(reps: results)
                        } catch {
                            Representative.loadedReps.removeAll()
                            Representative.loadedSens.removeAll()
                            print("Unable to decode Representatives from state")
                            print(error)
                        }
                        
                        
                    } else {
                        Representative.loadedReps.removeAll()
                        Representative.loadedSens.removeAll()
                    }
                    
                    completion()
                })
            } else {
                Representative.loadedReps.removeAll()
                Representative.loadedSens.removeAll()
            }
            
            completion()
        }
    }
    
    
    static func loadRepsWith(zipcode: String, completion: @escaping () -> Void) {
        
        let url = URL(string: zipAllRepURL + zipcode)!
        
        NetworkController.fetchDataFrom(url: url) { (data) in
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    let repDictionary = try decoder.decode(IntermediateRep.self, from: data)
                    NetworkController.setReps(reps: repDictionary.results)
                } catch {
                    Representative.loadedReps.removeAll()
                    Representative.loadedSens.removeAll()
                    print("Unable to decode Representatives from zipcode")
                    print(error)
                }
                
            } else {
                Representative.loadedReps.removeAll()
                Representative.loadedSens.removeAll()
            }
            
            completion()
        }
    }
    
    
    static func loadRandomUsers(amount: String, completion: @escaping () -> Void) {
        
        let url = URL(string: randomUserURL + amount)!
        
        NetworkController.fetchDataFrom(url: url) { (data) in
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    let userDictionary = try decoder.decode(intermediateUser.self, from: data)
                    RandomUser.loadedUsers = userDictionary.results
                } catch {
                    RandomUser.loadedUsers = []
                    print("Unable to decode Random Users")
                    print(error)
                }
                
            } else {
                RandomUser.loadedUsers = []
            }
            
            completion()
        }
    }
    
    
    static func loadNobelPrizesFrom(year: String, completion: @escaping () -> Void) {
        
        let url = URL(string: NetworkController.nobelPrizeURL + year)!
        print("NobelPrizeURL: \(url.absoluteString)")
        
        NetworkController.fetchDataFrom(url: url) { (data) in
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    let prizeDictionary = try decoder.decode(IntermediateNobelPrize.self, from: data)
                    NobelPrize.loadedPrizes = prizeDictionary.prizes
                } catch {
                    NobelPrize.loadedPrizes = []
                    print("Unable to decode Nobel Prizes")
                    print(error)
                }
                
            } else {
                NobelPrize.loadedPrizes = []
            }
            
            completion()
        }
    }
    
}

