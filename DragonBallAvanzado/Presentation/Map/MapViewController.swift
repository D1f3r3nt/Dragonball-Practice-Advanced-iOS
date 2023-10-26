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
}

// MARK: - States -
enum MapViewState {
    case loading(_ isLoading: Bool)
    case update(hero: Hero?, locations: HeroLocations)
}

// MARK: - View -
class MapViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var worldView: MKMapView!
    
    var viewModel: MapViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setObservers()
        self.viewModel?.handleViewDidLoad()
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
                }
            }
        }
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
