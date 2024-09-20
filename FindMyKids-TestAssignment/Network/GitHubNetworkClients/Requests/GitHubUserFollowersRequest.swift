import Foundation

struct GitHubUserFollowersRequest: NetworkRequest {

    private let userLogin: String
    var endpoint: URL? {
        return URL(string: "https://api.github.com/users/\(userLogin)/followers")
    }

    init(userLogin: String) {
        self.userLogin = userLogin
    }
}
