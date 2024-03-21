//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 13/03/24.
//

import UIKit

protocol UserInfoViewControllerDelegate: AnyObject {
    func didTapGitHubProfile()
    func didTapGetFollowers()
}

class UserInfoViewController: UIViewController {
    var follower: Follower?
    var user: User?
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var headerViewHeightContraint: NSLayoutConstraint = .init()
    var itemOneTopContraint: NSLayoutConstraint = .init()
    weak var delegate: FollowerListViewControllerDelegate?

    init(follower: Follower? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.follower = follower
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureDoneButton()
        layoutUI()
        configureChildViewControllers()
    }

    private func configureDoneButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
    }

    @objc
    func dismissVC() {
        dismiss(animated: true)
    }

    private func getUser() async {
        showLoadingView()
        do {
            guard let follower = follower else { return }
            user = try await NetworkManager.shared.getUser(for: follower.login)
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

    private func configureChildViewControllers() {
        Task {
            await getUser()
            configureUIElements(with: user)
        }
    }

    private func configureUIElements(with user: User?) {
        let headerInfoVC = HeaderUserInfoViewController(user: user)
        let repoItemVC = GFRepoItemViewController(user: user)
        let followerItemVC = GFFollowerItemViewController(user: user)

        repoItemVC.delegate = self
        followerItemVC.delegate = self

        add(childVC: headerInfoVC, to: headerView)
        add(childVC: repoItemVC, to: itemViewOne)
        add(childVC: followerItemVC, to: itemViewTwo)

        dateLabel.text = "GitHub since \(user?.createdAt.convertToMonthYearFormat() ?? "N/A")"

        setBioSpaceIfNeeded(headerInfoVC: headerInfoVC)
    }

    private func setBioSpaceIfNeeded(headerInfoVC: HeaderUserInfoViewController) {
        let padding: CGFloat = 20

        if (user?.bio) != nil {
            guard let userCardView = headerInfoVC.userCardView else {
                return
            }
            headerView.removeConstraints([headerViewHeightContraint, itemOneTopContraint])
            itemOneTopContraint = itemViewOne.topAnchor.constraint(
                equalTo: userCardView.bioLabel.bottomAnchor,
                constant: padding
            )
            NSLayoutConstraint.activate([
                itemOneTopContraint
            ])
        }
    }

    @MainActor
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

    private func layoutUI() {
        let itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]

        let padding: CGFloat = 20
        let itemHeight: CGFloat = 150

        itemViews.forEach { itemView in
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -padding
                )
            ])
        }

        headerViewHeightContraint = headerView.heightAnchor.constraint(equalToConstant: 100)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            headerViewHeightContraint
        ])

        itemOneTopContraint = itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding)
        NSLayoutConstraint.activate([
            itemOneTopContraint,
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalTo: itemViewOne.heightAnchor),

            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}

// MARK: UserInfoViewControllerDelegate

extension UserInfoViewController: UserInfoViewControllerDelegate {
    func didTapGitHubProfile() {
        // Show safari VC
        guard let url = URL(string: user?.htmlUrl ?? "") else {
            presentGFAlertOnMainThread(
                title: "Invalid URL",
                message: "The url attached to this user is invalid.",
                buttonTitle: "Ok"
            )
            return
        }
        presentSafariVC(with: url)
    }

    func didTapGetFollowers() {
        // Dismiss view
        // Tell follower list screen the new user
        guard let login = user?.login else {
            presentGFAlertOnMainThread(
                title: "Invalid username",
                message: "The username attached to this user is invalid.",
                buttonTitle: "Ok"
            )
            return
        }
        guard let followers = user?.followers, followers != 0 else {
            presentGFAlertOnMainThread(
                title: "No followers",
                message: "This user has no followers.",
                buttonTitle: "Ok"
            )
            return
        }
        delegate?.didRequestFollowers(for: login)
        dismissVC()
    }
}
