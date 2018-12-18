//
//  RandomUser.swift
//  API Projects
//
//  Created by Gabriel Blaine Palmer on 12/12/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import Foundation

struct RandomUser: Decodable {
    var firstName: String
    var lastName: String
    var gender: String
    var age: Int
    var pictureURL: String
    var address: String
    
    static var loadedUsers: [RandomUser] = []
    
    enum CodingKeys: String, CodingKey {
        case gender
        case nameInfo = "name"
        case dobInfo = "dob"
        case pictureInfo = "picture"
        case addressInfo = "location"
    }
    
    enum NestedInfoKeys: String, CodingKey {
        case firstName = "first"
        case lastName = "last"
        case pictureURL = "large"
        case age
        //address
        case street
        case city
        case state
        
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.gender = try valueContainer.decode(String.self, forKey: CodingKeys.gender).capitalized
        
        let nameInfo = try valueContainer.nestedContainer(keyedBy: NestedInfoKeys.self, forKey: CodingKeys.nameInfo)
        self.firstName = try nameInfo.decode(String.self, forKey: NestedInfoKeys.firstName).capitalized
        self.lastName = try nameInfo.decode(String.self, forKey: NestedInfoKeys.lastName).capitalized
        
        let dobInfo = try valueContainer.nestedContainer(keyedBy: NestedInfoKeys.self, forKey: CodingKeys.dobInfo)
        self.age = try dobInfo.decode(Int.self, forKey: NestedInfoKeys.age)
        
        let pictureInfo = try valueContainer.nestedContainer(keyedBy: NestedInfoKeys.self, forKey: CodingKeys.pictureInfo)
        self.pictureURL = try pictureInfo.decode(String.self, forKey: NestedInfoKeys.pictureURL)
        
        let addressInfo = try valueContainer.nestedContainer(keyedBy: NestedInfoKeys.self, forKey: CodingKeys.addressInfo)
        let street = try addressInfo.decode(String.self, forKey: NestedInfoKeys.street)
        let city = try addressInfo.decode(String.self, forKey: NestedInfoKeys.city)
        let state = try addressInfo.decode(String.self, forKey: NestedInfoKeys.state)
        self.address = "\(street.capitalized), \(city.capitalized), \(state.capitalized)"
    }
    
}

struct intermediateUser: Decodable {
    var results: [RandomUser]
}
