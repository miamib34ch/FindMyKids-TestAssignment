import UIKit

final class UserDetailCell: UICollectionViewCell, ReuseIdentifying {
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let companyLabel = UILabel()
    private let emailLabel = UILabel()
    private let blogLabel = UILabel()
    private let locationLabel = UILabel()
    private let infoTitleLabel = UILabel()
    private let bioLabel = UILabel()

    private var imageLoadingTask: Task<Void, Never>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        imageLoadingTask?.cancel()
        avatarImageView.image = UIImage(resource: .userPicMock)
    }

    // TODO: можно интерактивные ссылки сделать
    func configure(with user: GitHubUserDetail) {
        nameLabel.text = user.name
        companyLabel.text = user.company
        emailLabel.text = user.email
        blogLabel.text = user.blog
        locationLabel.text = user.location
        bioLabel.text = user.bio ?? UserDetailCellConstants.Strings.noData

        if let url = URL(string: user.avatarUrl) {
            loadAvatarImage(from: url)
        }
    }

    private func setupView() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(companyLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(blogLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(infoTitleLabel)
        contentView.addSubview(bioLabel)

        backgroundColor = UserDetailCellConstants.Color.background
        layer.cornerRadius = UserDetailCellConstants.Layout.cellCornerRadius

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = UserDetailCellConstants.Layout.avatarCornerRadius

        nameLabel.font = UserDetailCellConstants.Font.header
        nameLabel.textColor = .black

        companyLabel.font = UserDetailCellConstants.Font.description
        companyLabel.textColor = UserDetailCellConstants.Color.descriptionText

        emailLabel.font = UserDetailCellConstants.Font.description
        emailLabel.textColor = UserDetailCellConstants.Color.descriptionText

        blogLabel.font = UserDetailCellConstants.Font.description
        blogLabel.textColor = UserDetailCellConstants.Color.descriptionText

        locationLabel.font = UserDetailCellConstants.Font.description
        locationLabel.textColor = UserDetailCellConstants.Color.descriptionText

        infoTitleLabel.font = UserDetailCellConstants.Font.header
        infoTitleLabel.text = UserDetailCellConstants.Strings.bioHeader
        infoTitleLabel.textAlignment = .center
        infoTitleLabel.textColor = .black

        bioLabel.font = UserDetailCellConstants.Font.description
        bioLabel.numberOfLines = .zero
        bioLabel.textColor = UserDetailCellConstants.Color.descriptionText

        avatarImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(UserDetailCellConstants.Layout.contentOffset)
            make.height.equalTo(UserDetailCellConstants.Layout.avatarHeight)
            make.width.equalTo(UserDetailCellConstants.Layout.avatarWidth)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UserDetailCellConstants.Layout.contentOffset)
            make.trailing.equalToSuperview().offset(-UserDetailCellConstants.Layout.contentOffset)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(UserDetailCellConstants.Layout.contentOffset * 5/4)
        }

        companyLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(UserDetailCellConstants.Layout.contentOffset / 2)
            make.trailing.equalTo(nameLabel).offset(-UserDetailCellConstants.Layout.contentOffset / 2)
            make.leading.equalTo(nameLabel)
        }

        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(companyLabel.snp.bottom).offset(UserDetailCellConstants.Layout.contentOffset / 8)
            make.trailing.equalTo(companyLabel).offset(-UserDetailCellConstants.Layout.contentOffset / 8)
            make.leading.equalTo(companyLabel)
        }

        blogLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(UserDetailCellConstants.Layout.contentOffset / 8)
            make.trailing.equalTo(emailLabel).offset(-UserDetailCellConstants.Layout.contentOffset / 8)
            make.leading.equalTo(emailLabel)
        }

        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(blogLabel.snp.bottom).offset(UserDetailCellConstants.Layout.contentOffset / 8)
            make.leading.equalTo(blogLabel)
            make.trailing.equalTo(blogLabel).offset(-UserDetailCellConstants.Layout.contentOffset / 8)
        }

        infoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(UserDetailCellConstants.Layout.contentOffset * 5/4)
            make.leading.equalToSuperview().offset(UserDetailCellConstants.Layout.contentOffset)
            make.trailing.equalToSuperview().offset(-UserDetailCellConstants.Layout.contentOffset)
            make.height.equalTo(UserDetailCellConstants.Layout.headerHeight)
        }

        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(infoTitleLabel.snp.bottom).offset(UserDetailCellConstants.Layout.contentOffset / 2)
            make.leading.equalToSuperview().offset(UserDetailCellConstants.Layout.contentOffset)
            make.trailing.equalToSuperview().offset(-UserDetailCellConstants.Layout.contentOffset)
            make.bottom.equalToSuperview().offset(-UserDetailCellConstants.Layout.contentOffset)
        }
    }

    private func loadAvatarImage(from url: URL) {
        imageLoadingTask = Task { [weak self] in
            if  let self,
                let data = try? await fetchData(from: url) {
                avatarImageView.image = UIImage(data: data)
            }
        }
    }

    private func fetchData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
