//
//  SplashViewController.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 19/10/23.
//

import UIKit

// MARK: - Delegate -
protocol SplashViewControllerProtocol {
    var viewState: ((SpalshViewState) -> Void)? {get set}
    var heroesViewModel: HeroesViewControllerDelegate { get }
    var loginViewModel: LoginViewControllerProtocol { get }
    
    func handleViewDidLoad()
}

// MARK: - States -
enum SpalshViewState {
    case navigateToLogin
    case navigateToHeroes
}

// MARK: - View -
class SplashViewController: UIViewController {

    var viewModel: SplashViewControllerProtocol?
    
    // MARK: - Overrides -
    override func viewDidLoad() {
        super.viewDidLoad()
        setObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.handleViewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
    
    // MARK: - Privates -
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
