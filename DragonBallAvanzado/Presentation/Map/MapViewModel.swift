//
//  MapViewModel.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 26/10/23.
//

import Foundation

class MapViewModel: MapViewControllerProtocol {
    
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProvierProtocol
    
    private let heroCoreData: HeroCoreData = .init()
    private let locationCoreData: LocationCoreData = .init()
    
    var viewState: ((MapViewState) -> Void)?
    
    init(
        apiProvider: ApiProviderProtocol,
        secureDataProvider: SecureDataProvierProtocol
    ) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    func handleViewDidLoad() {
        defer { viewState?(.loading(false)) }
        
        viewState?(.loading(true))
        
        DispatchQueue.global().async {
            guard let token = self.secureDataProvider.getToken() else {
                return
            }
            
            self.heroCoreData.getHeroes().forEach { hero in
                // BDD
                let dataLocations = self.locationCoreData.getLocations(by: hero.id ?? "")
                if  !dataLocations.isEmpty {
                    self.viewState?(.update(hero: hero, locations: dataLocations ))
                    print("DETAIL MAP - FROM BDD")
                    
                // API
                } else {
                    self.apiProvider.getLocations(
                        by: hero.id,
                        token: token
                    ) { [weak self] heroLocation in
                        
                        self?.locationCoreData.manageLocations(of: heroLocation)
                        
                        self?.viewState?(.update(hero: hero, locations: heroLocation))
                    }
                    print("DETAIL MAP - FROM API")
                }
            }
            
        }
    }
    
    func goToDetail(of id: String) {
        if id.isEmpty {
            return
        }
        
        guard let hero = self.heroCoreData.getHero(by: id) else {
            return
        }
        
        self.viewState?(.navigateToDetail(hero: hero))
    }
    
    func heroDetailViewModel(hero: Hero) -> HeroDetailViewControllerProtocol {
        HeroDetailViewModel(
            hero: hero,
            apiProvider: apiProvider,
            secureDataProvider: secureDataProvider
        )
    }
}
