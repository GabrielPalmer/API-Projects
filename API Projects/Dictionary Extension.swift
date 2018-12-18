//
//  Dictionary Extension.swift
//  API Projects
//
//  Created by Gabriel Blaine Palmer on 12/18/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import Foundation

extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}
