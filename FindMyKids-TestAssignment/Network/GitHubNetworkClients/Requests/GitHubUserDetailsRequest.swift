import Foundation

struct GitHubUserDetailsRequest: NetworkRequest {

    private let userLogin: String
    var endpoint: URL? {
        return URL(string: "https://api.github.com/users/\(userLogin)")
    }

    init(userLogin: String) {
        self.userLogin = userLogin
    }
}
