//
//  HeroCellView.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 17/10/23.
//

import UIKit
import Kingfisher

class HeroCellView: UITableViewCell {
    
    static let identifier: String = "HeroCellView"
    static let estimatedHeight: CGFloat = 256
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        name.text = nil
        heroDescription.text = nil
        photo.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 8
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.4
        
        selectionStyle = .none
    }
    
    func updateView(
        name: String? = nil,
        photo: String? = nil,
        description: String? = nil
    ) {
        self.name.text = name
        self.heroDescription.text = description
        
        self.photo.kf.setImage(with: URL(string: photo ?? ""))
    }
}
