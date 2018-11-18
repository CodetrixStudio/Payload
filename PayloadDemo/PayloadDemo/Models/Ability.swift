//
//  Ability.swift
//  PayloadDemo
//
//  Created by Parveen Khatkar on 17/11/18.
//  Copyright © 2018 Codetrix Studio. All rights reserved.
//

import Foundation

struct Ability: Codable {
    let id: Int?
    let name, description: String?
    let isUltimate: Bool?
    let url: String?
}

struct Page<T>: Codable where T: Codable {
    let total: Int?
    let first, next, previous: String?
    let last: String?
    let data: [T]?
}
