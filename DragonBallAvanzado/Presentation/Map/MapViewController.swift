//
//  MapViewController.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 26/10/23.
//

import UIKit
import MapKit

// MARK: - Delegate -
protocol MapViewControllerProtocol {
    var viewState: ((MapViewState) -> Void)? { get set }
    
    func handleViewDidLoad()
    func goToDetail(of id: String)
    func heroDetailViewModel(hero: Hero) -> HeroDetailViewControllerProtocol
}

// MARK: - States -
enum MapViewState {
    case loading(_ isLoading: Bool)
    case update(hero: Hero?, locations: HeroLocations)
    case navigateToDetail(hero: Hero)
}

// MARK: - View -
class MapViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var worldView: MKMapView!
    
    var viewModel: MapViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
        self.setObservers()
        self.viewModel?.handleViewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MAP_TO_HERO_DEATIL" {
            guard let hero = sender as? Hero,
                  let heroDetailViewController = segue.destination as? HeroDetailViewController,
                  let detailViewModel = viewModel?.heroDetailViewModel(hero: hero) else {
                return
            }
            
            heroDetailViewController.viewModel = detailViewModel
        }
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.loadingView.isHidden = !isLoading
                        break
                    case .update(hero: let hero, locations: let locations):
                        self?.updateViews(hero: hero, heroLocations: locations)
                        break
                    case .navigateToDetail(hero: let hero):
                        self?.performSegue(withIdentifier: "MAP_TO_HERO_DEATIL", sender: hero)
                        break
                }
            }
        }
    }
    
    private func initialize() {
        worldView.delegate = self
    }
    
    private func updateViews(hero: Hero?, heroLocations: HeroLocations) {
        heroLocations.forEach { heroLocation in
            worldView.addAnnotation(
                MapAnnotation(
                    title: hero?.name,
                    info: hero?.id,
                    coordinate: .init(
                        latitude: Double(heroLocation.latitude ?? "") ?? 0.0,
                        longitude: Double(heroLocation.longitude ?? "") ?? 0.0
                    )
                )
            )
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let point = annotation as? MapAnnotation else {
            return
        }
        self.viewModel?.goToDetail(of: point.info ?? "")
    }
}
