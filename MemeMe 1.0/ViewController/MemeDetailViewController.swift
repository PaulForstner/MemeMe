//
//  MemeDetailViewController.swift
//  MemeMe 1.0
//
//  Created by Paul Forstner on 25.06.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Properties
    
    var meme: Meme?
    
    // MARK: - Life cyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMeme()
        createBarItems()
    }
    
    // MARK: Configure UI
    
    private func createBarItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(presentMemeMeVC))
    }
    
    // MARK: - Helper
    
    private func setMeme() {
        
        guard let meme = self.meme else {
            showAlert(Alerts.NoMemeTitle, message: Alerts.NoMemeMessage)
            return
        }
        
        imageView.image = meme.memedImage
    }
    
    @objc private func presentMemeMeVC() {
        
        guard let meme = self.meme else {
            showAlert(Alerts.NoMemeTitle, message: Alerts.NoMemeMessage)
            return
        }
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MemeMeViewController") as? MemeMeViewController else {
            showAlert(Alerts.ErrorTitle, message: Alerts.ErrorMessage)
            return
        }
        vc.editingMeme = meme
        navigationController?.pushViewController(vc, animated: true)
    }
}
