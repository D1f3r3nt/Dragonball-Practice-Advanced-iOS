//
//  HeroeCoreData.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 19/10/23.
//

import Foundation
import CoreData

class HeroCoreData {
    
    func manageHeroes(of heroes: Heroes) {
        deleteAll()
        saveHeroes(of: heroes)
    }
    
    func testSaved() {
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        let fetch = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
        
        guard let persons = try? moc.fetch(fetch)
            else {
            return
        }
        
        print(persons.count)
        print(persons.first ?? "NONE Data")
    }
    
    private func saveHeroes(of heroes: Heroes) {
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        guard let entityHero = NSEntityDescription.entity(forEntityName: HeroDAO.entityName, in: moc)
            else {
            return
        }
        
        heroes.forEach { hero in
            let heroDao = HeroDAO(entity: entityHero, insertInto: moc)
            heroDao.heroDescription = hero.description
            heroDao.favorite = hero.isFavorite ?? false
            heroDao.name = hero.name
            heroDao.id = hero.id
            heroDao.photo = hero.photo
        }
        
        try? moc.save()
    }
    
    private func deleteAll() {
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        let requestAllHeroes = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
        
        guard let persons = try? moc.fetch(requestAllHeroes)
            else {
            return
        }
        
        persons.forEach { person in
            moc.delete(person)
        }
        
        try? moc.save()
    }
}
