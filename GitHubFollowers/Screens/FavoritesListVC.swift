//
//  FavoritesListViewController.swift
//  GitHubFollowers
//
//  Created by Collin Browse on 4/3/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class FavoritesListViewController: GFDataLoadingVC {

    
    let tableView = UITableView()
    var favorites : [Follower] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        configureViewController()
        configureTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    
    func getFavorites() {
        
        PersistenceManager.retrieveFavorites { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                self.updateUI(with: favorites)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something Went Wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    
    func updateUI(with favorites: [Follower]) {
        
        if favorites.isEmpty {
            self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen", in: self.view)
        } else {
            self.favorites = favorites
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    

    func configureTableView() {
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }

}


extension FavoritesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        cell.set(favorite: favorites[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = FollowerListVC(username: favorite.login)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
    
        let favorite = favorites[indexPath.row]
        PersistenceManager.update(with: favorite, actionType: .remove) { [weak self] (error) in
            guard let self = self else { return }
            
            if error == nil {
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
            } else {
                self.presentGFAlertOnMainThread(title: "Unable to remove favorite", message: error!.rawValue, buttonTitle: "Fine")
            }
        }
    }
    
}
