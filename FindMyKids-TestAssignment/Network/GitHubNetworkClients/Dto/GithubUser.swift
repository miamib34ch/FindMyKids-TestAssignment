struct GitHubUser: Codable, Hashable {
    let login: String
    let id: Int
    let avatarUrl: String
    let followersUrl: String

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarUrl = "avatar_url"
        case followersUrl = "followers_url"
    }
}
