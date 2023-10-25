//
//  LocationDAO.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 26/10/23.
//

import Foundation
import CoreData

@objc(LocationDAO)
class LocationDAO: NSManagedObject {
    static let entityName = "LocationDAO"
    
    @NSManaged var id: String?
    @NSManaged var date: String?
    @NSManaged var latitud: String?
    @NSManaged var longitud: String?
    @NSManaged var hero: String?
}
