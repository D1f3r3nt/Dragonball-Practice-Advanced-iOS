//
//  HeroesViewModel.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 17/10/23.
//

import Foundation

class HeroesViewModel: HeroesViewControllerDelegate {

    private let heroCoreData: HeroCoreData = .init()
    
    private let apiProvider: ApiProviderProtocol
    private let secureData: SecureDataProvierProtocol
    
    var viewState: ((HeroesViewState) -> Void)?
    
    private var heroesFromInternet: Heroes = []
    private var heroesPrint: Heroes = []
    
    init(
        apiProvider: ApiProviderProtocol,
        secureData: SecureDataProvierProtocol
    ) {
        self.apiProvider = apiProvider
        self.secureData = secureData
    }
    
    //MARK: - Extended -
    
    func onViewAppear() {
        self.viewState?(.loading(true))
        
        DispatchQueue.global().async {
            defer { self.viewState?(.loading(false)) }
            
            guard let token = self.secureData.getToken() else {
                return
            }
            
            // BDD
            let dataHeroes = self.heroCoreData.getHeroes()
            if !dataHeroes.isEmpty {
                self.setClassData(of: dataHeroes)
                print("FROM BDD")
                
            // API
            } else {
                self.apiProvider.getHeroes(by: nil, token: token) { heroes in
                    self.setClassData(of: heroes, save: true)
                }
                self.viewState?(.fromApi)
                print("FROM API")
            }
        }
    }
    
    func heroDetailViewModel(index: Int) -> HeroDetailViewControllerProtocol {
        HeroDetailViewModel(
            hero: heroesPrint[index],
            apiProvider: apiProvider,
            secureDataProvider: secureData
        )
    }
    
    func splashViewModel() -> SplashViewControllerProtocol {
        SplashViewModel(
            secureData: secureData
        )
    }
    
    func logout() {
        secureData.clear()
        viewState?(.logout)
    }
    
    func clearMemory() {
        self.heroCoreData.deleteAll()
        self.onViewAppear()
    }
    
    func heroBy(index: Int) -> Hero? {
        if index >= 0 && index < heroesCount() {
            return heroesPrint[index]
        } else {
            return nil
        }
    }
    
    func filterHeroes(by heroName: String) {
        if heroName.isEmpty {
            heroesPrint = heroesFromInternet
        } else {
            heroesPrint = heroesFromInternet.filter { hero in
                hero.name?.lowercased().contains(heroName.lowercased()) ?? true
            }
        }
        
        self.viewState?(.updateData)
    }
    
    func heroesCount() -> Int {
        heroesPrint.count
    }
    
    private func setClassData(of heroes: Heroes, save: Bool = false) {
        self.heroesFromInternet = heroes
        self.heroesPrint = self.heroesFromInternet
        
        if (save) {
            self.heroCoreData.manageHeroes(of: heroes)
        }
        
        self.viewState?(.updateData)
    }
}
