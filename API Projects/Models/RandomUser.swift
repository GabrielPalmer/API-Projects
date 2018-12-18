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
    
    static var loadedUsers: [RandomUser] = []
    
    enum CodingKeys: String, CodingKey {
        case gender
        case nameInfo = "name"
        case dobInfo = "dob"
        case pictureInfo = "picture"
    }
    
    enum NestedInfoKeys: String, CodingKey {
        case firstName = "first"
        case lastName = "last"
        case pictureURL = "medium"
        case age
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.gender = try valueContainer.decode(String.self, forKey: CodingKeys.gender)
        
        let nameInfo = try valueContainer.nestedContainer(keyedBy: NestedInfoKeys.self, forKey: CodingKeys.nameInfo)
        self.firstName = try nameInfo.decode(String.self, forKey: NestedInfoKeys.firstName)
        self.lastName = try nameInfo.decode(String.self, forKey: NestedInfoKeys.lastName)
        
        let dobInfo = try valueContainer.nestedContainer(keyedBy: NestedInfoKeys.self, forKey: CodingKeys.dobInfo)
        self.age = try dobInfo.decode(Int.self, forKey: NestedInfoKeys.age)
        
        let pictureInfo = try valueContainer.nestedContainer(keyedBy: NestedInfoKeys.self, forKey: CodingKeys.pictureInfo)
        self.pictureURL = try pictureInfo.decode(String.self, forKey: NestedInfoKeys.pictureURL)
    }
    
}

struct intermediateUser: Decodable {
    var results: [RandomUser]
}
