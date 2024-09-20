import UIKit
import SnapKit

final class UsersViewController: UIViewController {

    private var users: [GitHubUser] = []
    private var usersDetailed: Set<GitHubUserDetail> = []

    private var collectionView: UICollectionView!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupCollectionView()
        setupObservers()

        // TODO: показать заглушку
        GitHubUsersNetworkService.shared.fetchUsers(whichFollow: nil)
    }

    private func setupView() {
        title = UsersViewControllerConstants.Strings.title
        view.backgroundColor = .white
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (view.frame.width - UsersViewControllerConstants.Layout.contentSpacing) / 2 - UsersViewControllerConstants.Layout.contentOffset
        layout.itemSize = CGSize(width: itemWidth, height: UsersViewControllerConstants.Layout.cellHeight)
        layout.minimumLineSpacing = UsersViewControllerConstants.Layout.contentSpacing
        layout.minimumInteritemSpacing = UsersViewControllerConstants.Layout.contentSpacing
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserPreviewCell.self)

        collectionView.backgroundColor = .white

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(UsersViewControllerConstants.Layout.contentOffset)
        }
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onDataReceived),
            name: GitHubUsersNetworkService.usersDataReceivedNotification,
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
            self.users = service.users
            self.usersDetailed = service.usersDetailed
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }

    @objc private func onErrorReceived(_ notification: Notification) {
        print("Fetch users data error")
        // TODO: показать алерт и кнопку повторить
    }
}

extension UsersViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UserPreviewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let user = usersDetailed.first(where: { $0.id == users[indexPath.item].id }) {
            cell.configure(with: user)
        } else {
            print("No user details found")
            cell.configure(with: users[indexPath.item])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let userDetail = usersDetailed.first(where: { $0.id == users[indexPath.item].id }) {
            let usersDetailVc = UserDetailViewController(user: userDetail)
            navigationController?.pushViewController(usersDetailVc, animated: true)
        } else {
            print("No user details found")
            // TODO: показать алерт с ошибкой
        }
    }
}
