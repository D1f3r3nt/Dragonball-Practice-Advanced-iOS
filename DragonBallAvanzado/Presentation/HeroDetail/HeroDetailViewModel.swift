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
            
            self.apiProvider.getLocations(
                by: self.hero.id,
                token: token
            ) { [weak self] heroLocation in
                self?.heroLocation = heroLocation
                self?.state?(.update(hero: self?.hero, locations: heroLocation))
            }
        }
    }
}
