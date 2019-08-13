//
//  MemeCollectionViewCell.swift
//  MemeMe 1.0
//
//  Created by Paul Forstner on 24.06.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!

    // MARK: - Configuration
    
    public func configureCell(with meme: Meme?) {
        
        imageView.image = meme?.memedImage
        imageView.contentMode = .scaleAspectFill
    }
}
