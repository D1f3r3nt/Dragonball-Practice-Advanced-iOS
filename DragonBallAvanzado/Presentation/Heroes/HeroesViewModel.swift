//
//  HeroesViewModel.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 17/10/23.
//

import Foundation

class HeroesViewModel: HeroesViewControllerDelegate {

    private let apiProvider: ApiProviderProtocol
    private let secureData: SecureDataProvierProtocol
    
    var viewState: ((HeroesViewState) -> Void)?
    
    private var heroes: Heroes = []
    
    init(
        apiProvider: ApiProviderProtocol,
        secureData: SecureDataProvierProtocol
    ) {
        self.apiProvider = apiProvider
        self.secureData = secureData
    }
    
    func onViewAppear() {
        self.viewState?(.loading(true))
        
        DispatchQueue.global().async {
            defer { self.viewState?(.loading(false)) }
            
            guard let token = self.secureData.getToken() else {
                return
            }
            
            self.apiProvider.getHeroes(by: nil, token: token) { heroes in
                self.heroes = heroes
                
                /*
                let moc = CoreDataStack.shared.persistentContainer.viewContext
                let entityHero = NSEntityDescription.entity(forEntityName: HeroDAO.entityName, in: moc)
                
                let heroDao = HeroDAO(entity: entityHero, insertInto: moc)
                */
                self.viewState?(.updateData)
            }
        }
    }
    
    func heroBy(index: Int) -> Hero? {
        if index >= 0 && index < heroesCount() {
            return heroes[index]
        } else {
            return nil
        }
    }
    
    func heroesCount() -> Int {
        heroes.count
    }
}
