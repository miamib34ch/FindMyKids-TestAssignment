import UIKit

enum UserDetailCellConstants {

    // TODO: поменять на локализацию
    enum Strings {
        static let bioHeader: String = "Информация"
        static let noData: String = "Отсутствует"
    }

    enum Layout {
        static let contentOffset: CGFloat = 16.0
        static let avatarHeight: CGFloat = 96.0
        static let avatarWidth: CGFloat = 99.0
        static let avatarCornerRadius: CGFloat = 16.0
        static let cellCornerRadius: CGFloat = 24.0
        static let headerHeight: CGFloat = 16.0
    }

    enum Font {
        static let header: UIFont = .systemFont(ofSize: 16, weight: .medium)
        static let description: UIFont = .systemFont(ofSize: 14)
    }

    enum Color {
        static let background: UIColor = UIColor(resource: .userCard)
        static let descriptionText: UIColor = UIColor(resource: .userDescription)
    }
}
