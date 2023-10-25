//
//  LocationMapper.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 26/10/23.
//

import Foundation
class LocationMapper {
    static func mapperDao(of locationsDao: [LocationDAO]) -> HeroLocations {
        locationsDao.map { locationDao in
            HeroLocation(
                id: locationDao.id,
                latitude: locationDao.latitud,
                longitude: locationDao.longitud,
                date: locationDao.date,
                hero: Hero(
                    id: locationDao.hero,
                    name: nil,
                    description: nil,
                    photo: nil,
                    isFavorite: nil)
            )
        }
    }
}
