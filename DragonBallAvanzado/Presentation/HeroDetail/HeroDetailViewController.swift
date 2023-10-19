//
//  HeroDetailViewController.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 19/10/23.
//

import UIKit
import MapKit
import Kingfisher

// MARK: - Delegate -
protocol HeroDetailViewControllerProtocol {
    var state: ((HeroDetailViewState) -> Void)? { get set }
    
    func handleViewDidLoad()
}

// MARK: - States -
enum HeroDetailViewState {
    case loading(_ isLoading: Bool)
    case update(hero: Hero?, locations: HeroLocations)
}

// MARK: - View -
class HeroDetailViewController: UIViewController {
    // MARK: - Outlets -
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    var viewModel: HeroDetailViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
        viewModel?.handleViewDidLoad()
    }
    // MARK: - Actions -
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Privates -
    private func initViews() {
        
    }
    
    private func setObservers() {
        viewModel?.state = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    break
                case .update(hero: let hero, locations: let locations):
                    self?.updateViews(hero: hero, heroLocations: locations)
                }
            }
        }
    }
    
    private func updateViews(hero: Hero?, heroLocations: HeroLocations) {
        image.kf.setImage(with: URL(string: hero?.photo ?? ""))
        makeRounded(image: image)
        
        nameLabel.text = hero?.name
        descriptionLabel.text = hero?.description
        
        heroLocations.forEach { heroLocation in
            mapView.addAnnotation(
                HeroAnnotation(
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

    private func makeRounded(image: UIImageView) {
        image.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.6)
        image.layer.borderWidth = 1
        image.clipsToBounds = true
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.masksToBounds = false
    }
}
