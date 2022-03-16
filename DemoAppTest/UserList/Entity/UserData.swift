//
//  UserData.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 1/31/22.
//

import Foundation

/// Data Model for network response
struct UserData: Decodable, Hashable {
    /// internal ID
    let id: String?

    /// Name of cat (e.g. "Somali")
    let name: String?

    /// Description
    let description: String?

    /// Range (e.g. 12-16)
    let life_span: String?

    /// Reference
    let wikipedia_url: String?

    /// General traits and characteristic rankings (0-10)
    let adaptability: Int?
    let affection_level: Int?
    let child_friendly: Int?
    let dog_friendly: Int?
    let energy_level: Int?
    let grooming: Int?
    let health_issues: Int?
    let intelligence: Int?
    let shedding_level: Int?
    let social_needs: Int?
    let stranger_friendly: Int?
    let vocalisation: Int?
}

struct UserDetails: Decodable {
    let breeds: [UserDetails]?
    struct UserDetails: Decodable {
        let id: String?
        let name: String?
        let temperament: String?
    }

    let url: String? // image URL
}
