//
//  GFAlertContainerView.swift
//  GitHubFollowers
//
//  Created by Collin Browse on 4/21/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class GFAlertContainerView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
    }

}
