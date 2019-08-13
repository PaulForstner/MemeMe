//
//  MemeTableViewController.swift
//  MemeMe 1.0
//
//  Created by Paul Forstner on 24.06.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var memes: [Meme] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        return appDelegate.memes
    }
    private lazy var dataSource: MemeTableViewDataSource = {
        return MemeTableViewDataSource(didSelect: { [weak self] (meme) in
            
            self?.presentMemeDetailVC(with: meme)
            }, remove: { (meme) in
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                appDelegate.memes.removeAll(where: {$0.memedImage == meme.memedImage})
        })
    }()
    
    // MARK: - Life cyle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.configure(tableView: tableView)
        createBarItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dataSource.set(memes: memes)
        tableView.reloadData()
    }
    
    // MARK: Configure UI
    
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
