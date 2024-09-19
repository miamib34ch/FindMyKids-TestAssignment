import Foundation

struct GitHubUsersRequest: NetworkRequest {
    var endpoint: URL? {
        return URL(string: "https://api.github.com/users")
    }
}
