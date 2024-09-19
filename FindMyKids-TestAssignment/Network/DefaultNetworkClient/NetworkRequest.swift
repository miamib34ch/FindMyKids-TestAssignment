import Foundation

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: String { get }
}


extension NetworkRequest {
    var httpMethod: String { "GET" }
}
