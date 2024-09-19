struct GitHubUser: Codable {
    let login: String
    let id: Int
    let avatarUrl: String
    let reposUrl: String
    let followersUrl: String

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarUrl = "avatar_url"
        case reposUrl = "repos_url"
        case followersUrl = "followers_url"
    }
}
