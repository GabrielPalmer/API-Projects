//
//  NobelPrize.swift
//  API Projects
//
//  Created by Gabriel Blaine Palmer on 12/12/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import Foundation

struct NobelPrize: Decodable {
    
    var category: String
    var laureates: [Laureate]
    
    static var loadedPrizes: [NobelPrize] = []
    
    enum CodingKeys: String, CodingKey {
        case category
        case laureatesInfo = "laureates"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.category = try valueContainer.decode(String.self, forKey: CodingKeys.category)
        self.laureates = try valueContainer.decode([Laureate].self, forKey: CodingKeys.laureatesInfo)
        
    }
}

struct Laureate: Decodable {
    var firstName: String
    var lastName: String
    var motivation: String?
    
    enum LaureateCodingKeys: String, CodingKey {
        case firstName = "firstname"
        case lastName = "surname"
        case motivation
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: LaureateCodingKeys.self)
        self.firstName = try valueContainer.decode(String.self, forKey: LaureateCodingKeys.firstName)
        self.lastName = try valueContainer.decode(String.self, forKey: LaureateCodingKeys.lastName)
        self.motivation = try? valueContainer.decode(String.self, forKey: LaureateCodingKeys.motivation)
    }
}

struct IntermediateNobelPrize: Decodable {
    var prizes: [NobelPrize]
}
