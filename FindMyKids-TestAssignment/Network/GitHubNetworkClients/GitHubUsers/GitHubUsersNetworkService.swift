import Foundation

final class GitHubUsersNetworkService: GitHubUsersNetworkServiceProtocol {

    static let dataReceivedNotification = Notification.Name(rawValue: "GitHubUsersNetworkServiceDidReceiveData")
    static let errorNotification = Notification.Name(rawValue: "GitHubUsersNetworkServiceError")

    private let defaultNetworkClient = DefaultNetworkClient()
    private var task: NetworkTask?

    private(set) var users: [GitHubUser]?

    static let shared: GitHubUsersNetworkServiceProtocol = GitHubUsersNetworkService()
    private init() {}

    func fetchUsers() {
        if task != nil { return }
        let request = GitHubUsersRequest()
        task = defaultNetworkClient.send(request: request, type: [GitHubUser].self, onResponse: resultHandler)
    }

    private func resultHandler(_ result: Result<[GitHubUser], Error>) {
        task = nil

        switch result {
            case .success(let users):
                self.users = users
                NotificationCenter.default.post(name: GitHubUsersNetworkService.dataReceivedNotification, object: self)
            case .failure(let error):
                print("Error fetching users: \(error)")
                NotificationCenter.default.post(name: GitHubUsersNetworkService.errorNotification, object: self)
        }
    }
}

