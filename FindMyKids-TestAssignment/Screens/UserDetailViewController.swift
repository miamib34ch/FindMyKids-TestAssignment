import UIKit
import SnapKit

final class UserDetailViewController: UIViewController {

    private let user: GitHubUserDetail
    private var followers: [GitHubUser] = []
    private var followersDetailed: Set<GitHubUserDetail> = []

    private var collectionView: UICollectionView!

    init(user: GitHubUserDetail) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        configureView(with: user)
        setupObservers()

        GitHubUsersNetworkService.shared.fetchUsers(whichFollow: user.toGitHubUser())
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = UserDetailViewControllerConstants.Layout.contentSpacing
        layout.minimumInteritemSpacing = UserDetailViewControllerConstants.Layout.contentSpacing

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(UserDetailCell.self)
        collectionView.register(UserPreviewCell.self)
        collectionView.register(CustomHeaderView.self)

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(UserDetailViewControllerConstants.Layout.contentOffset)
        }
    }

    private func configureView(with user: GitHubUserDetail) {
        title = user.login
        view.backgroundColor = .white

        navigationItem.backButtonTitle = nil
        let backImage = UIImage(systemName: "arrow.left")
        let backButton = UIBarButtonItem(image: backImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapBackButton))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }

    // TODO: можно архитектурно вынести в общий класс повторяющийся код с логикой
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onDataReceived),
            name: GitHubUsersNetworkService.followersDataReceivedNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onErrorReceived),
            name: GitHubUsersNetworkService.errorNotification,
            object: nil
        )
    }

    @objc private func onDataReceived(_ notification: Notification) {
        if let service = notification.object as? GitHubUsersNetworkServiceProtocol {
            followers = service.users
            followersDetailed = service.usersDetailed
            Task { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }

    @objc private func onErrorReceived(_ notification: Notification) {
        print("Fetch users data error")
        // TODO: показать алерт и кнопку повторить
    }

    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension UserDetailViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0: return 1
            case 1: return followers.count
            default: return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            case 0:
                let cell: UserDetailCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(with: user)
                return cell
            case 1:
                let cell: UserPreviewCell = collectionView.dequeueReusableCell(for: indexPath)
                let follower = followers[indexPath.item]
                if let followerDetailed = followersDetailed.first(where: { $0.id == follower.id }) {
                    cell.configure(with: followerDetailed)
                } else {
                    cell.configure(with: follower)
                }
                return cell
            default:
                fatalError("Unexpected section")
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: CustomHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
        switch indexPath.section {
            case 0:
                headerView.configure()
            case 1:
                headerView.configure(with: UserDetailViewControllerConstants.Strings.title)
            default:
                fatalError("Unexpected section")
        }
        return headerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UserDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == .zero {
            //TODO: высчитывать динамическую высоту
            return CGSize(width: collectionView.frame.width, height: UserDetailViewControllerConstants.Layout.cellHeight)
        } else {
            let itemWidth = (collectionView.frame.width - UserDetailViewControllerConstants.Layout.contentSpacing) / 2
            return CGSize(width: itemWidth, height: UserDetailViewControllerConstants.Layout.cellHeight)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == .zero ? .zero : CGSize(width: collectionView.frame.width, height: UserDetailViewControllerConstants.Layout.headerHeight)
    }

}

// MARK: - UIScrollViewDelegate

extension UserDetailViewController: UIScrollViewDelegate {

    // TODO: можно поизучать анимационное переключение
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let visibleIndexPaths = collectionView.indexPathsForVisibleItems.sorted().first else { return }
        switch visibleIndexPaths.section {
            case 0:
                self.title = user.login
            case 1:
                self.title = UserDetailViewControllerConstants.Strings.title
            default:
                break
        }
    }
}
