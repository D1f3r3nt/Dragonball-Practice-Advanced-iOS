//
//  LocationCoreData.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 26/10/23.
//

import Foundation
import CoreData

class LocationCoreData {
    
    func manageLocations(of locations: HeroLocations) {
        deleteAll()
        saveLocations(of: locations)
    }
    
    func getLocations(by hero: String) -> HeroLocations {
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        let fetch = NSFetchRequest<LocationDAO>(entityName: LocationDAO.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", hero )
        
        guard let locations = try? moc.fetch(fetch)
            else {
            return []
        }
        
        return LocationMapper.mapperDao(of: locations)
    }
    
    private func saveLocations(of locations: HeroLocations) {
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        guard let entityHero = NSEntityDescription.entity(
            forEntityName: LocationDAO.entityName,
            in: moc
        ) else {
            return
        }
        
        locations.forEach { location in
            let locationDao = LocationDAO(entity: entityHero, insertInto: moc)
            locationDao.date = location.date
            locationDao.id = location.id
            locationDao.latitud = location.latitude
            locationDao.longitud = location.longitude
            locationDao.hero = location.hero?.id
        }
        
        try? moc.save()
    }
    
    public func deleteAll() {
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        let requestAllLocations = NSFetchRequest<LocationDAO>(entityName: LocationDAO.entityName)
        
        guard let locations = try? moc.fetch(requestAllLocations)
            else {
            return
        }
        
        locations.forEach { location in
            moc.delete(location)
        }
        
        try? moc.save()
    }
}
