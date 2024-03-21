//
//  FollowerListViewController.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 08/03/24.
//

import UIKit

protocol FollowerListViewControllerDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class FollowerListViewController: UIViewController {
    enum Section {
        case main
    }

    var username: String = ""
    var collectionView: UICollectionView?
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>?
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false

    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        Task {
            await getFollowers()
        }
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view)
        )
        guard let collectionView = collectionView else {
            fatalError("Collection view is nil when configuring it")
        }
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        configureAddButton()
    }

    private func configureAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func getFollowers() async {
        showLoadingView()
        do {
            let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
            if followers.count < 100 {
                hasMoreFollowers = false
            }
            self.followers.append(contentsOf: followers)
            if self.followers.isEmpty {
                let message = "This user doesn't have any followers. Go Follow them 😄."
                showEmptyStateView(with: message, in: view)
                dismissLoadingView()
                return
            }
            updateData(on: self.followers)
            dismissLoadingView()
        } catch {
            dismissLoadingView()
            presentGFAlertOnMainThread(
                title: "Bad stuff happened",
                message: error.localizedDescription,
                buttonTitle: "Ok"
            )
        }
    }

    func configureDataSource() {
        guard let collectionView = collectionView else {
            fatalError("Collection view is nil when configuring it")
        }
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(
            collectionView: collectionView
        ) { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FollowerCell.reuseID,
                for: indexPath
            ) as? FollowerCell
            cell?.set(follower: follower)
            return cell
        }
    }

    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    @objc
    func addButtonTapped() {
        showLoadingView()
        Task {
            do {
                let user = try await NetworkManager.shared.getUser(for: username)
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                try PersistanceManager.updateWith(favorite: favorite, actionType: .add)
                presentGFAlertOnMainThread(
                    title: "Success!",
                    message: "\(favorite.login) has been added to your favorites! 🥳",
                    buttonTitle: "Ok"
                )
                dismissLoadingView()
            } catch {
                dismissLoadingView()
                presentGFAlertOnMainThread(
                    title: "Something went wrong",
                    message: error.localizedDescription,
                    buttonTitle: "Ok"
                )
            }
        }
    }
}

// MARK: UICollectionViewDelegate

extension FollowerListViewController: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate _: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > (contentHeight - height) {
            guard hasMoreFollowers else { return }
            page += 1
            Task {
                await getFollowers()
            }
        }
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        let userInfoVC = UserInfoViewController(follower: follower)
        userInfoVC.delegate = self
        let navController = UINavigationController(rootViewController: userInfoVC)
        navigationController?.present(navController, animated: true)
    }
}

// MARK: UISearchResultsUpdating

extension FollowerListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { follower in
            follower.login.lowercased().contains(filter.lowercased())
        }
        updateData(on: filteredFollowers)
    }
}

// MARK: FollowerListViewControllerDelegate

extension FollowerListViewController: FollowerListViewControllerDelegate {
    func didRequestFollowers(for username: String) {
        Task {
            self.username = username
            title = username
            followers.removeAll()
            filteredFollowers.removeAll()
            page = 1
            isSearching = false
            navigationItem.searchController?.isActive = false
            hasMoreFollowers = true
            if let frame = navigationItem.searchController?.searchBar.frame {
                collectionView?.scrollRectToVisible(frame, animated: false)
            } else {
                collectionView?.setContentOffset(.zero, animated: false)
            }
            await getFollowers()
        }
    }
}
