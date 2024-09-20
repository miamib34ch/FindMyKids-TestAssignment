import Foundation

protocol GitHubUsersNetworkServiceProtocol {
    static var shared: GitHubUsersNetworkServiceProtocol { get }
    static var dataReceivedNotification: NSNotification.Name { get }
    static var errorNotification: NSNotification.Name { get }

    var users: [GitHubUser] { get }
    var userDetails: Set<GitHubUserDetail> { get }

    func fetchUsers()
}
