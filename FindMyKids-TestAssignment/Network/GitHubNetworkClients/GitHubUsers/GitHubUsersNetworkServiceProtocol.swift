import Foundation

protocol GitHubUsersNetworkServiceProtocol {
    static var shared: GitHubUsersNetworkServiceProtocol { get }
    static var usersDataReceivedNotification: NSNotification.Name { get }
    static var followersDataReceivedNotification: NSNotification.Name { get }
    static var errorNotification: NSNotification.Name { get }

    var users: [GitHubUser] { get }
    var usersDetailed: Set<GitHubUserDetail> { get }

    func fetchUsers(whichFollow: GitHubUser?)
}
