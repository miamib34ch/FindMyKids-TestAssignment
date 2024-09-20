import UIKit

enum UserPreviewCellConstants {

    // TODO: поменять на локализацию
    enum Strings {
        static let followersCounter: String = " подписчиков"
        static let reposCounter: String = " репозиториев"
    }

    enum Layout {
        static let contentOffset: CGFloat = 16.0
        static let avatarHeight: CGFloat = 126.0
        static let avatarWidth: CGFloat = 122.0
        static let avatarCornerRadius: CGFloat = 16.0
        static let cellCornerRadius: CGFloat = 24.0
    }

    enum Font {
        static let login: UIFont = .systemFont(ofSize: Layout.contentOffset, weight: .bold)
        static let description: UIFont = .systemFont(ofSize: 12)
    }

    enum Color {
        static let background: UIColor = UIColor(resource: .userCard)
        static let descriptionText: UIColor = UIColor(resource: .userDescription)
    }
}
