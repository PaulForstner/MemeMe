//
//  MemeCollectionViewController.swift
//  MemeMe 1.0
//
//  Created by Paul Forstner on 24.06.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: - Properties
    
    private var memes: [Meme] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        return appDelegate.memes
    }
    private lazy var dataSource: MemeCollectionViewDataSource = {
        return MemeCollectionViewDataSource(didSelect: { [weak self] (meme) in
            self?.presentMemeDetailVC(with: meme)
        })
    }()
    
    // MARK: - Life cyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.configure(collectionView: collectionView)
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dataSource.set(memes: memes)
        collectionView.reloadData()
    }
    
    // MARK: Configure UI
    
    private func configureUI() {
        
        let space:CGFloat = 8.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        createBarItems()
    }
    
    private func createBarItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentMemeMeVC))
    }
    
    // MARK: - Helper
    
    private func presentMemeDetailVC(with meme: Meme) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as? MemeDetailViewController else {
            showAlert(Alerts.ErrorTitle, message: Alerts.ErrorMessage)
            return
        }
        vc.meme = meme
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func presentMemeMeVC() {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MemeMeViewController") as? MemeMeViewController else {
            showAlert(Alerts.ErrorTitle, message: Alerts.ErrorMessage)
            return
        }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
