//
//  User.swift
//  SearchTattoo
//
//  Created by Hertz on 12/21/22.
//

import Foundation

// MARK: - Tattooist
struct Tattooist: Codable {
    let results: [TattooShopResponse]?
}

// MARK: - Result
struct TattooShopResponse: Codable {
    let objectID, phoneNumber, createdAt, updatedAt: String?
    let kakaoURL, instaURL: String?
    let shopName, profileImageString: String?
    let location: Location?
    let adress, instaTextString, kakaoTextString, phoneCallTextString: String?
    let instaImageString, kakaoImageString, phoneImageString: String?

    enum CodingKeys: String, CodingKey {
        case objectID = "objectId"
        case phoneNumber, createdAt, updatedAt, kakaoURL, instaURL, shopName, profileImageString, location, adress
        case instaTextString, kakaoTextString, phoneCallTextString, instaImageString, kakaoImageString, phoneImageString
    }
}

// MARK: - Location
struct Location: Codable {
    let type: String?
    let latitude, longitude: Double?

    enum CodingKeys: String, CodingKey {
        case type = "__type"
        case latitude, longitude
    }
}

