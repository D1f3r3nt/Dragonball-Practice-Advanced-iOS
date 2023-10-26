//
//  LoginViewModel.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 10/10/23.
//

import Foundation

final class LoginViewModel: LoginViewControllerProtocol {
    
    private let apiProvider: ApiProviderProtocol
    private let secureData: SecureDataProvierProtocol
    
    var viewState: ((LoginViewState) -> Void)?
    var heroesViewModel: HeroesViewControllerDelegate {
        HeroesViewModel(apiProvider: apiProvider, secureData: secureData)
    }
    
    init(
        apiProvider: ApiProviderProtocol,
        secureData: SecureDataProvierProtocol
    ) {
        self.apiProvider = apiProvider
        self.secureData = secureData
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loginSucces),
            name: NotificationCenter.apiProviderNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func loginSucces(_ notification: Notification) {
        guard let token = notification.userInfo?[NotificationCenter.tokenKey] as? String,
            !token.isEmpty else {
            viewState?(.loading(false))
            viewState?(.invalidLogin)
            return
        }
        
        secureData.save(token: token)
        viewState?(.loading(false))
        viewState?(.navigateToNext)
    }
    
    func isValid(email: String?) -> Bool {
        email?.isEmpty == false && email?.contains("@") ?? false
    }
    
    func isValid(password: String?) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0) >= 4
    }
    
    private func doLoginWith(email: String, password: String) {
        apiProvider.login(for: email, with: password)
    }
    
    // MARK: - Extended -
    func handleLoginPressed(email: String?, password: String?) {
        viewState?(.loading(true))
        
        DispatchQueue.global().async {
            guard self.isValid(email: email) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorEmail("Email no valido"))
                return
            }
            
            guard self.isValid(password: password) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorEmail("Contraseña incorrecta"))
                return
            }
            
            self.doLoginWith(email: email ?? "", password: password ?? "")
        }
        
        
    }
}
