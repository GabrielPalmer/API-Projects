//
//  Representative.swift
//  API Projects
//
//  Created by Gabriel Blaine Palmer on 12/12/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import Foundation

struct Representative: Codable {
    var name: String
    var state: String
    var district: String
    var party: String
    var website: String
    
    static var loadedReps: [Representative] = []
    static var loadedSens: [Representative] = []
    static let postalCodes: [String : String] = [
        "alabama" : "AL",
        "alaska" : "AK",
        "arizona" : "AZ",
        "arkansas" : "AR",
        "california" : "CA",
        "colorado" : "CO",
        "conneticut" : "CT",
        "delaware" : "DE",
        "district of columbia" : "DC",
        "florida" : "FL",
        "georgia" : "GA",
        "hawaii" : "HI",
        "idaho" : "ID",
        "illinois" : "IL",
        "indiana" : "IN",
        "iowa" : "IA",
        "kansas" : "KS",
        "kentucky" : "KY",
        "louisiana" : "LA",
        "maine" : "ME",
        "maryland" : "MD",
        "massachusetts" : "MA",
        "michigan" : "MI",
        "minnesota" : "MN",
        "mississippi" : "MS",
        "missouri" : "MO",
        "montana" : "MT",
        "nebraska" : "NE",
        "nevada" : "NV",
        "new hampshire" : "NH",
        "new jersey" : "NJ",
        "new mexico" : "NM",
        "new York" : "NY",
        "north carolina" : "NC",
        "north dakota" : "ND",
        "ohio" : "OH",
        "oklahoma" : "OK",
        "oregon" : "OR",
        "pennsylvania" : "PA",
        "rhode island" : "RI",
        "south carolina" : "SC",
        "south dakota" : "SD",
        "tennessee" : "TN",
        "texas" : "TX",
        "utah" : "UT",
        "vermont" : "VT",
        "virginia" : "VA",
        "washington" : "WA",
        "west virginia" : "WV",
        "wisconsin" : "WI",
        "wyoming" : "WY"
    ]
    
    enum CodingKeys: String, CodingKey {
        case name
        case state
        case district
        case party
        case website = "link"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
        self.state = try valueContainer.decode(String.self, forKey: CodingKeys.state)
        self.district = try valueContainer.decode(String.self, forKey: CodingKeys.district)
        self.party = try valueContainer.decode(String.self, forKey: CodingKeys.party)
        self.website = try valueContainer.decode(String.self, forKey: CodingKeys.website)
    }
}

struct IntermediateRep: Codable {
    let results: [Representative]
}
