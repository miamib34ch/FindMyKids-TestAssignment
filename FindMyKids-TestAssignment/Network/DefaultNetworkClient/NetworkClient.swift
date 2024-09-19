import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
}

protocol NetworkClient {
    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask?
}

struct DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(
        session: URLSession = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }
    
    @discardableResult
    func send<T: Decodable>(request: NetworkRequest, type: T.Type, onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask? {
        guard let urlRequest = create(request: request) else { return nil }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                onResponse(.failure(NetworkClientError.urlSessionError))
                return
            }
            
            guard 200 ..< 300 ~= response.statusCode else {
                onResponse(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                return
            }
            
            if let data = data {
                self.parse(data: data, type: type, onResponse: onResponse)
                return
            } else if let error = error {
                onResponse(.failure(NetworkClientError.urlRequestError(error)))
                return
            } else {
                assertionFailure("Неожиданное условие при обработке сетевого ответа")
                return
            }
        }

        task.resume()
        
        return DefaultNetworkTask(dataTask: task)
    }
    
    private func create(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endpoint else {
            assertionFailure("Пустая ссылка при отправке сетевого запроса")
            return nil
        }
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod
        
        return urlRequest
    }
    
    private func parse<T: Decodable>(data: Data, type _: T.Type, onResponse: @escaping (Result<T, Error>) -> Void) {
        do {
            let response = try decoder.decode(T.self, from: data)
            onResponse(.success(response))
        } catch {
            onResponse(.failure(NetworkClientError.parsingError))
        }
    }
}
