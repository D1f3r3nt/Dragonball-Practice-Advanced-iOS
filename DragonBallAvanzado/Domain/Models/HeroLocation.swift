//
//  HeroLocation.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 19/10/23.
//

import Foundation

public typealias HeroLocations = [HeroLocation]

public struct HeroLocation: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case hero
        case latitude = "latitud"
        case longitude = "longitud"
        case date = "dateShow"
    }
    
    public let id: String?
    public let latitude: String?
    public let longitude: String?
    public let date: String?
    public let hero: Hero?
}
