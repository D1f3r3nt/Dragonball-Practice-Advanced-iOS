//
//  HeroesViewController.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 17/10/23.
//

import UIKit

protocol HeroesViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)? { get set }
    
    func heroesCount() -> Int
    func onViewAppear()
    func heroBy(index: Int) -> Hero?
}

enum HeroesViewState {
    case loading(_ isLoading: Bool)
    case updateData
}

class HeroesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loadingView: UIView!
    var viewModel: HeroesViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        setObservers()
        initViews()
        self.viewModel?.onViewAppear()
    }
    
    private func initViews() {
        tableView.register(
            UINib(
                nibName: HeroCellView.identifier,
                bundle: nil
            ),
            forCellReuseIdentifier: HeroCellView.identifier
        )
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.loadingView.isHidden = !isLoading
                        break
                        
                    case .updateData:
                        self?.tableView.reloadData()
                        break
                }
            }
        }
    }
}

extension HeroesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.heroesCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        HeroCellView.estimatedHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HeroCellView.identifier,
            for: indexPath
        ) as? HeroCellView else {
            return UITableViewCell()
        }
        
        if let hero = viewModel?.heroBy(index: indexPath.row) {
            cell.updateView(
                name: hero.name,
                photo: hero.photo,
                description: hero.description
            )
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Navigation
    }
}
