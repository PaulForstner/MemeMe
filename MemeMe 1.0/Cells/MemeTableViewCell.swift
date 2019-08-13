//
//  MemeTableViewCell.swift
//  MemeMe 1.0
//
//  Created by Paul Forstner on 24.06.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var memedImageView: UIImageView!
    @IBOutlet private weak var topTextLabel: UILabel!
    @IBOutlet private weak var botTextLabel: UILabel!

    // MARK: - Configuration
    
    public func configureCell(with meme: Meme?) {
        
        memedImageView.image = meme?.memedImage
        memedImageView.contentMode = .scaleAspectFill
        topTextLabel.text = meme?.topText
        botTextLabel.text = meme?.bottomText
    }
}
