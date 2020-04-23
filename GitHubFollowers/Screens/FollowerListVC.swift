//
//  FollowerListVC.swift
//  GitHubFollowers
//
//  Created by Collin Browse on 4/6/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit



class FollowerListVC: GFDataLoadingVC {

    enum Section {
        case main
    }
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var isSearching = false
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var page = 1
    var hasMoreFollowers = true
    var isLoadingMoreFollowers = false
    
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers()
        configureDataSource()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureViewController() {
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    
    func configureSearchController() {
        
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self // setting the delegate
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
    }
    

    func configureCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        collectionView.delegate = self
    }
    
    
    func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            
            return cell
        })
    }
    
    
    
    func getFollowers() {
        
        isLoadingMoreFollowers = true
        showLoadingView()
        
        NetworkManager.shared.getFollowers(for: username, page: self.page) { [weak self] result in
            
            guard let self = self else { return }
            self.dismissLoadingView()
            self.isLoadingMoreFollowers = false
            
            switch result {
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "OK")
            case .success(let followers):
                self.updateUI(with: followers)
            }
        }
        
    }
    
    
    func updateUI(with followers: [Follower]) {
        
        if followers.count < 100 {
            self.hasMoreFollowers = false
        }
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            DispatchQueue.main.async {
                let message = "This user doesn't have any followers. Go follow them!"
                self.showEmptyStateView(with: message, in: self.view)
            }
            return
        }
        self.updateData(on: self.followers)
    }
    
    
    func updateData(on followers: [Follower]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
    }
    
    
    @objc func addButtonTapped() {
        
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] (result) in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                self.addUserToFavorites(user: user)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    
    func addUserToFavorites(user: User) {
        
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.update(with: favorite, actionType: .add) { [weak self] (error) in
            guard let self = self else { return }
            
            guard let error = error else {
                self.presentGFAlertOnMainThread(title: "Success", message: "User added to favorites", buttonTitle: "OK")
                return
            }
            
            self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
        }
        
    }
    
}


extension FollowerListVC: UICollectionViewDelegate {
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height, hasMoreFollowers, !isLoadingMoreFollowers {
            page += 1
            getFollowers()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true, completion: nil)
        
    }
}


extension FollowerListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // Grab text in search bar and make sure it's not empty
        guard let filter = searchController.searchBar.text,
            !filter.isEmpty else {
                filteredFollowers.removeAll()
                updateData(on: followers)
                isSearching = false
                return
        }
        
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
    
}


extension FollowerListVC: UserInfoVCDelegate {
   
    func didRequestFollowers(for username: String) {
        // Update the username and reload the collection view
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        isSearching = false
        hasMoreFollowers = true
        collectionView.scrollsToTop = true
        getFollowers()
    }
    
    
}
