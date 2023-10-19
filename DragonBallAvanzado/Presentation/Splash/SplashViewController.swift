//
//  SplashViewController.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 19/10/23.
//

import UIKit

protocol SplashViewControllerProtocol {
    var viewState: ((SpalshViewState) -> Void)? {get set}
    var heroesViewModel: HeroesViewControllerDelegate { get }
    var loginViewModel: LoginViewControllerProtocol { get }
    
    func handleViewDidLoad()
}

enum SpalshViewState {
    case navigateToLogin
    case navigateToHeroes
}

class SplashViewController: UIViewController {

    var viewModel: SplashViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setObservers()
        viewModel?.handleViewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SPLASH_TO_HEROES",
              let heroesViewController = segue.destination as? HeroesViewController {
            heroesViewController.viewModel = viewModel?.heroesViewModel
        }
        
        if segue.identifier == "SPLASH_TO_LOGIN",
              let loginViewController = segue.destination as? LoginViewController {
            loginViewController.viewModel = viewModel?.loginViewModel
        }
        
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .navigateToLogin:
                        self?.performSegue(withIdentifier: "SPLASH_TO_LOGIN", sender: nil)
                    
                    case .navigateToHeroes:
                        self?.performSegue(withIdentifier: "SPLASH_TO_HEROES", sender: nil)
                        
                }
            }
        }
    }

}
