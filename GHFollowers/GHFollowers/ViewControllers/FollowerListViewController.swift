//
//  FollowerListViewController.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 08/03/24.
//

import UIKit

class FollowerListViewController: UIViewController {
    enum Section {
        case main
    }

    var username: String = ""
    var collectionView: UICollectionView?
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>?
    var followers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
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

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func getFollowers() async {
        // With callback
//        NetworkManager.shared.getFollowers(for: username, page: 1) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case let .success(followers):
//                self.followers = followers
//                self.updateData()
//            case let .failure(error):
//                self.presentGFAlertOnMainThread(
//                    title: "Bad stuff happened",
//                    message: error.localizedDescription,
//                    buttonTitle: "Ok"
//                )
//            }
//        }

        // With async/await
        showLoadingView()
        do {
            let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
            if followers.count < 100 {
                hasMoreFollowers = false
            }
            self.followers.append(contentsOf: followers)
            updateData()
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

    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        dataSource?.apply(snapshot, animatingDifferences: true)
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
}
