//
//  MemeTableViewDataSource.swift
//  MemeMe 1.0
//
//  Created by Paul Forstner on 24.06.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeTableViewDataSource: NSObject {

    // MARK: - Typealias
    
    typealias DidSelectHandler = (_ meme: Meme) -> Void
    
    // MARK: - Properties - Handler
    
    private var didSelectHandler: DidSelectHandler
    private var removeHandler: DidSelectHandler
    
    // MARK: - Properties
    
    private var memes: [Meme] = []
    
    // MAKR: - Public
    
    func configure(tableView: UITableView) {
        
        tableView.register(UINib(nibName: "MemeTableViewCell", bundle: nil), forCellReuseIdentifier: "MemeTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    func set(memes: [Meme]) {
        self.memes = memes
    }
    
    // MARK: - Initializer
    
    init(didSelect: @escaping DidSelectHandler, remove: @escaping DidSelectHandler) {
        
        self.didSelectHandler = didSelect
        self.removeHandler = remove
    }
}

// MARK: - UITableViewDataSource

extension MemeTableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as? MemeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(with: memes.item(at: indexPath.row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete, let meme = memes.item(at: indexPath.row) else {
                return
        }
        memes.removeAll(where: {$0.memedImage == meme.memedImage})
        tableView.deleteRows(at: [indexPath], with: .fade)
        removeHandler(meme)
    }
}

// MARK: - UITableViewDelegate

extension MemeTableViewDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let meme = memes.item(at: indexPath.row) else {
            return
        }
        didSelectHandler(meme)
    }
}
