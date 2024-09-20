import UIKit

protocol ReuseIdentifying {
    static var defaultReuseIdentifier: String { get }
}

extension ReuseIdentifying where Self: UICollectionViewCell {
    static var defaultReuseIdentifier: String {
        NSStringFromClass(self).components(separatedBy: ".").last ?? NSStringFromClass(self)
    }
}

extension ReuseIdentifying where Self: UICollectionReusableView {
    static var defaultReuseIdentifier: String {
        NSStringFromClass(self).components(separatedBy: ".").last ?? NSStringFromClass(self)
    }
}

extension UICollectionView {

    func register<T: UICollectionViewCell>(_: T.Type) where T: ReuseIdentifying {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReuseIdentifying {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            assertionFailure("Cannot dequeue cell: \(T.defaultReuseIdentifier) for: \(indexPath)")
            return T()
        }
        return cell
    }

    func cellForItem<T: UICollectionViewCell>(at indexPath: IndexPath) -> T where T: ReuseIdentifying {
        guard let cell = cellForItem(at: indexPath) as? T else {
            assertionFailure("Cannot find cell: \(T.defaultReuseIdentifier) for: \(indexPath)")
            return T()
        }
        return cell
    }
}

extension UICollectionView {

    func register<T: UICollectionReusableView>(_: T.Type) where T: ReuseIdentifying {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, for indexPath: IndexPath) -> T where T: ReuseIdentifying {
        guard let header = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            assertionFailure("Cannot dequeue cell: \(T.defaultReuseIdentifier) for: \(indexPath)")
            return T()
        }
        return header
    }
}
