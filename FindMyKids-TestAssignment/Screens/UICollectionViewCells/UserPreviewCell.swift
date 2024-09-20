import UIKit
import SnapKit

final class UserPreviewCell: UICollectionViewCell, ReuseIdentifying {
    
    private let avatarImageView = UIImageView()
    private let loginLabel = UILabel()
    private let followersLabel = UILabel()
    private let reposLabel = UILabel()

    private var imageLoadingTask: Task<Void, Never>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        imageLoadingTask?.cancel()
        avatarImageView.image = UIImage(resource: .userPicMock)
        loginLabel.text = nil
        followersLabel.text = nil
        reposLabel.text = nil
    }

    func configure(with user: GitHubUser) {
        commonConfigure(login: user.login,
                        followersCount: "...",
                        reposCount: "...",
                        avatarUrl: user.avatarUrl)
    }

    func configure(with user: GitHubUserDetail) {
        commonConfigure(login: user.login,
                        followersCount: "\(user.followers)",
                        reposCount: "\(user.publicRepos)",
                        avatarUrl: user.avatarUrl)
    }

    private func commonConfigure(login: String,
                                 followersCount: String,
                                 reposCount: String,
                                 avatarUrl: String) {
        loginLabel.text = login
        followersLabel.text = followersCount + UserPreviewCellConstants.Strings.followersCounter
        reposLabel.text = reposCount + UserPreviewCellConstants.Strings.reposCounter

        if let url = URL(string: avatarUrl) {
            loadAvatarImage(from: url)
        }
    }

    private func setupViews() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(loginLabel)
        contentView.addSubview(followersLabel)
        contentView.addSubview(reposLabel)

        backgroundColor = UserPreviewCellConstants.Color.background
        layer.cornerRadius = UserPreviewCellConstants.Layout.cellCornerRadius

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = UserPreviewCellConstants.Layout.avatarCornerRadius

        loginLabel.font = UserPreviewCellConstants.Font.login
        loginLabel.textAlignment = .center
        loginLabel.textColor = .black

        followersLabel.font = UserPreviewCellConstants.Font.description
        followersLabel.textAlignment = .center
        followersLabel.textColor = UserPreviewCellConstants.Color.descriptionText

        reposLabel.font = UserPreviewCellConstants.Font.description
        reposLabel.textAlignment = .center
        reposLabel.textColor = UserPreviewCellConstants.Color.descriptionText

        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UserPreviewCellConstants.Layout.contentOffset)
            make.centerX.equalToSuperview()
            make.height.equalTo(UserPreviewCellConstants.Layout.avatarHeight)
            make.width.equalTo(UserPreviewCellConstants.Layout.avatarWidth)
        }

        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(UserPreviewCellConstants.Layout.contentOffset * 5/4)
            make.leading.trailing.equalToSuperview().inset(UserPreviewCellConstants.Layout.contentOffset)
        }

        followersLabel.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(UserPreviewCellConstants.Layout.contentOffset / 2)
            make.leading.trailing.equalToSuperview().inset(UserPreviewCellConstants.Layout.contentOffset)
        }

        reposLabel.snp.makeConstraints { make in
            make.top.equalTo(followersLabel.snp.bottom).offset(UserPreviewCellConstants.Layout.contentOffset / 8)
            make.leading.trailing.equalToSuperview().inset(UserPreviewCellConstants.Layout.contentOffset)
        }
    }

    private func loadAvatarImage(from url: URL) {
        imageLoadingTask = Task {
            if let data = try? await fetchData(from: url) {
                avatarImageView.image = UIImage(data: data)
            }
        }
    }

    private func fetchData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
