import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let usersViewController = UsersViewController()
        let navigationController = CustomNavigationController(rootViewController: usersViewController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

