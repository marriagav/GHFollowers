//
//  FavoritesListViewController.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 07/03/24.
//

import UIKit

class FavoritesListViewController: UIViewController {
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
            if favorites.isEmpty {
                showEmptyStateView(with: "No favorites yet.\nAdd one on the follower screen.", in: view)
            } else {
                reloadTableViewData()
            }
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
        let followersListVC = FollowerListViewController()
        followersListVC.username = favorite.login
        followersListVC.title = favorite.login
        navigationController?.pushViewController(followersListVC, animated: true)
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }

        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        do {
            try PersistanceManager.updateWith(favorite: favorite, actionType: .remove)
        } catch {
            presentGFAlertOnMainThread(
                title: "Something went wrong",
                message: error.localizedDescription,
                buttonTitle: "Ok"
            )
        }
    }
}
