import Foundation

final class GitHubUsersNetworkService: GitHubUsersNetworkServiceProtocol {

    var isFollowersFetch: Bool = false
    static let usersDataReceivedNotification = Notification.Name(rawValue: "GitHubUsersNetworkServiceDidReceiveUsersData")
    static let followersDataReceivedNotification = Notification.Name(rawValue: "GitHubUsersNetworkServiceDidReceiveFollowersData")
    static let errorNotification = Notification.Name(rawValue: "GitHubUsersNetworkServiceError")

    private let defaultNetworkClient = DefaultNetworkClient()
    private var task: NetworkTask?

    private(set) var users: [GitHubUser] = []
    private(set) var usersDetailed: Set<GitHubUserDetail> = []

    static let shared: GitHubUsersNetworkServiceProtocol = GitHubUsersNetworkService()
    private init() {}

    func fetchUsers() {
        if task != nil { return }
        let request = GitHubUsersRequest()
        task = defaultNetworkClient.send(request: request, type: [GitHubUser].self, onResponse: resultHandler)
    }

    private func resultHandler(_ result: Result<[GitHubUser], Error>) {
        switch result {
            case .success(let users):
                self.users = users
                fetchUserDetails(for: users)
            case .failure(let error):
                task = nil
                print("Error fetching users: \(error)")
                NotificationCenter.default.post(name: GitHubUsersNetworkService.errorNotification, object: self)
        }
    }

    private func fetchUserDetails(for users: [GitHubUser]) {
        let dispatchGroup = DispatchGroup()

        for (index, user) in users.enumerated() {
            dispatchGroup.enter()
            fetchUserDetail(for: user, at: index) { result in
                switch result {
                    case .success(let userDetails):
                        self.usersDetailed.insert(userDetails)
                    case .failure(let error):
                        print("Error fetching user details for \(user.login): \(error)")
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else {
                NotificationCenter.default.post(name: GitHubUsersNetworkService.errorNotification, object: self)
                return
            }
            task = nil
            if isFollowersFetch {
                NotificationCenter.default.post(name: GitHubUsersNetworkService.followersDataReceivedNotification, object: self)
            } else {
                NotificationCenter.default.post(name: GitHubUsersNetworkService.usersDataReceivedNotification, object: self)
            }
        }
    }

    private func fetchUserDetail(for user: GitHubUser, at index: Int, completion: @escaping (Result<GitHubUserDetail, Error>) -> Void) {
        let request = GitHubUserDetailsRequest(userLogin: user.login)
        defaultNetworkClient.send(request: request, type: GitHubUserDetail.self) { result in
            switch result {
                case .success(let userDetails):
                    completion(.success(userDetails))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

