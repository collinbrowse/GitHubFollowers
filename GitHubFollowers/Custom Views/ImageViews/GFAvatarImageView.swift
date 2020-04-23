//
//  GFAvatarImageView.swift
//  GitHubFollowers
//
//  Created by Collin Browse on 4/9/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class GFAvatarImageView: UIImageView {

    let placeholderImage = Images.placeholder
    let cache = NetworkManager.shared.cache
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func downloadImage(fromURL urlString: String) {
        
        NetworkManager.shared.downloadImage(from: urlString) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        
    }

}
