//
//  MemeCollectionViewDataSource.swift
//  MemeMe 1.0
//
//  Created by Paul Forstner on 24.06.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeCollectionViewDataSource: NSObject {
    
    // MARK: - Typealias
    
    typealias DidSelectHandler = (_ meme: Meme) -> Void
    
    // MARK: - Properties - Handler
    
    private var didSelectHandler: DidSelectHandler
    
    // MARK: - Properties
    
    private var memes: [Meme] = []
    
    // MAKR: - Public
    
    func configure(collectionView: UICollectionView) {
        
        collectionView.register(UINib(nibName: "MemeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MemeCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func set(memes: [Meme]) {
        self.memes = memes
    }
    
    // MARK: - Initializer
    
    init(didSelect: @escaping DidSelectHandler) {
        self.didSelectHandler = didSelect
        
    }
    
}

// MARK: - UICollectionViewDataSource

extension MemeCollectionViewDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as? MemeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(with: memes.item(at: indexPath.row))
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MemeCollectionViewDataSource: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let meme = memes.item(at: indexPath.row) else {
            return
        }
        didSelectHandler(meme)
    }
}
