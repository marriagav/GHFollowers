//
//  FavoritesListViewController.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 07/03/24.
//

import UIKit

class FavoritesListViewController: GFDataLoadingViewController {
    let tableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }

    override func updateContentUnavailableConfiguration(using _: UIContentUnavailableConfigurationState) {
        if favorites.isEmpty {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = SFSymbols.star.symbolImage
            config.text = "No Favorites"
            config.secondaryText = "Add a favorite on the follower list screen"
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .systemBackground
        tableView.frame = view.bounds
        tableView.rowHeight = 80

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }

    func getFavorites() {
        do {
            favorites = try PersistanceManager.retrieveFavorites()
            reloadTableViewData()
            setNeedsUpdateContentUnavailableConfiguration()
        } catch {
            presentGFAlertOnMainThread(
                title: "Something went wrong",
                message: error.localizedDescription,
                buttonTitle: "Ok"
            )
        }
    }

    @MainActor
    func reloadTableViewData() {
        tableView.reloadData()
        view.bringSubviewToFront(tableView)
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension FavoritesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return favorites.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as? FavoriteCell else {
            fatalError("The cell was nil when configuring it")
        }
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let followersListVC = FollowerListViewController(username: favorite.login)
        navigationController?.pushViewController(followersListVC, animated: true)
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        let favorite = favorites[indexPath.row]

        do {
            try PersistanceManager.updateWith(favorite: favorite, actionType: .remove)
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            setNeedsUpdateContentUnavailableConfiguration()
        } catch {
            presentGFAlertOnMainThread(
                title: "Something went wrong",
                message: error.localizedDescription,
                buttonTitle: "Ok"
            )
        }
    }
}
