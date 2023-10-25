//
//  HeroMapper.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 25/10/23.
//

import Foundation

class HeroMapper {
    static func mapperDao(of heroesDao: [HeroDAO]) -> Heroes {
        heroesDao.map { heroDao in
            Hero(
                id: heroDao.id,
                name: heroDao.name,
                description: heroDao.heroDescription,
                photo: heroDao.photo,
                isFavorite: heroDao.favorite
            )
        }
    }
}
