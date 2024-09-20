import UIKit
import SnapKit

final class CustomHeaderView: UICollectionReusableView, ReuseIdentifying {

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String? = nil) {
        titleLabel.text = title
    }

    private func setupViews() {
        addSubview(titleLabel)
        backgroundColor = .white

        titleLabel.font = UserDetailViewControllerConstants.Font.header
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
