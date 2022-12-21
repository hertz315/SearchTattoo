//
//  TattooShop.swift
//  SearchTattoo
//
//  Created by Hertz on 12/22/22.
//

import Foundation
import CoreLocation

struct TattooShop: Identifiable, Hashable {
    var id = UUID()
    let objectID, phoneNumber: String
    let kakaoURL, instaURL: String
    let shopName, profileImageString: String
    let latitude: Double
    let longitude: Double
    let address: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(_ entity: TattooShopResponse){
        self.objectID = entity.objectID ?? ""
        self.phoneNumber = entity.phoneNumber ?? ""
        self.kakaoURL = entity.kakaoURL ?? ""
        self.instaURL = entity.instaURL ?? ""
        self.shopName = entity.shopName ?? ""
        self.profileImageString = entity.profileImageString ?? ""
        self.latitude = entity.location?.latitude ?? 0
        self.longitude = entity.location?.longitude ?? 0
        self.address = entity.adress ?? ""
    }
    
}
