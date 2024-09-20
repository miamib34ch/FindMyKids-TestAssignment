struct GitHubUserDetail: Decodable, Hashable {
    let login: String
    let id: Int
    let avatarUrl: String
    let followers: Int
    let publicRepos: Int
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let bio: String?

    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarUrl = "avatar_url"
        case followers
        case publicRepos = "public_repos"
        case name
        case company
        case blog
        case location
        case email
        case bio
    }
}
