//
//  SplashViewModel.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 19/10/23.
//

import Foundation

class SplashViewModel: SplashViewControllerProtocol {
    private let secureData: SecureDataProvierProtocol
    
    var heroesViewModel: HeroesViewControllerDelegate {
        HeroesViewModel(apiProvider: ApiProvider(), secureData: secureData)
    }
    
    var loginViewModel: LoginViewControllerProtocol {
        LoginViewModel(apiProvider: ApiProvider(), secureData: secureData)
    }
    
    var viewState: ((SpalshViewState) -> Void)?
    
    init(
        secureData: SecureDataProvierProtocol
    ) {
        self.secureData = secureData
    }
    
    // MARK: - Extended -
    func handleViewDidLoad() {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
            if self?.secureData.getToken() == nil {
                self?.viewState?(.navigateToLogin)
            } else {
                self?.viewState?(.navigateToHeroes)
            }
        }
    }
    
}
