//
//  HeroDetailViewModel.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 19/10/23.
//

import Foundation

class HeroDetailViewModel: HeroDetailViewControllerProtocol {
    
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProvierProtocol
    
    private let locationCoreData = LocationCoreData()
    
    var state: ((HeroDetailViewState) -> Void)?
    
    private var hero: Hero
    private var heroLocation: HeroLocations = []
    
    init(
        hero: Hero,
        apiProvider: ApiProviderProtocol,
        secureDataProvider: SecureDataProvierProtocol
    ) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.hero = hero
    }
    
    // MARK: - Extended -
    
    func handleViewDidLoad() {
        defer { state?(.loading(false)) }
        
        state?(.loading(true))
        
        DispatchQueue.global().async {
            guard let token = self.secureDataProvider.getToken() else {
                return
            }
            
            // BDD
            let dataLocations = self.locationCoreData.getLocations(by: self.hero.id ?? "")
            if !dataLocations.isEmpty {
                self.heroLocation = dataLocations
                self.state?(.update(hero: self.hero, locations: dataLocations))
                print("FROM BDD")
                
            // API
            } else {
                self.apiProvider.getLocations(
                    by: self.hero.id,
                    token: token
                ) { [weak self] heroLocation in
                    self?.heroLocation = heroLocation
                    
                    self?.locationCoreData.manageLocations(of: heroLocation)
                    
                    self?.state?(.update(hero: self?.hero, locations: heroLocation))
                }
                print("FROM API")
            }
        }
    }
}
