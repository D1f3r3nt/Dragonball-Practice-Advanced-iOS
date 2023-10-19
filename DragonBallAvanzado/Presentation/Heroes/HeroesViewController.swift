//
//  HeroesViewController.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 17/10/23.
//

import UIKit

// MARK: - Delegate -
protocol HeroesViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)? { get set }
    
    func heroesCount() -> Int
    func onViewAppear()
    func heroBy(index: Int) -> Hero?
    func heroDetailViewModel(index: Int) -> HeroDetailViewControllerProtocol
}

// MARK: - States -
enum HeroesViewState {
    case loading(_ isLoading: Bool)
    case updateData
}

// MARK: - View -
class HeroesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    
    var viewModel: HeroesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setObservers()
        initViews()
        self.viewModel?.onViewAppear()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "HEROES_TO_HERO_DETAIL",
              let index = sender as? Int,
              let heroDetailViewController = segue.destination as? HeroDetailViewController,
              let detailViewModel = viewModel?.heroDetailViewModel(index: index) else {
            return
        }
        
        heroDetailViewController.viewModel = detailViewModel
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

// MARK: - Extensions -
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
        performSegue(withIdentifier: "HEROES_TO_HERO_DETAIL", sender: indexPath.row)
    }
}
