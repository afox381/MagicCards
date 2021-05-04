import Foundation
import Combine

public enum RepositoryError: Error {
    /// Unexpected response from the network.
    case unexpectedResponse
    /// Network request failed, with the underlying error provided.
    case networkRequestFailed(underlyingError: Error)
    /// HTTP error with the HTTP status code provided.
    case httpError(statusCode: Int, responseCode: String?, defaultMessage: String?)
    /// Parsing failed, with additional details provided.
    case parsingFailed(details: String)
    
    case noData
    
    public struct ResponseKey {
        public static let responseCode = "code"
        public static let defaultMessage = "defaultMessage"
    }
    
    /// A description of the error.
    public var description: String {
        switch self {
        case .unexpectedResponse:
            return "Unexpected response"
        case .networkRequestFailed(let error):
            return error.localizedDescription
        case .httpError(let statusCode, let responseCode, let defaultMessage):
            return "HTTP status code \(statusCode)\n Response code: \(String(describing: responseCode))\n defaultMessage: \(String(describing: defaultMessage))"
        case .parsingFailed(let details):
            return "Parsing error: \(details)"
        case .noData:
            return "No data"
        }
    }
}

enum Url {
    static let base: String = "https://api.magicthegathering.io"
    static let v1: String = "v1"
    static let cards: String = "cards"
}

enum HttpMethod: String, Codable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum HTTPContentType: String {
    case applicationAtom = "application/atom+xml"
    case applicationJSON = "application/json"
    case applicationForm = "application/x-www-form-urlencoded"
}

public enum HTTPHeaderField: String {
    case contentType = "Content-type"
    case authorization = "Authorization"
}

class Repository {
    private let HTTPAcceptableCodes = 200...299
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func fetch<T: Decodable>(httpMethod: HttpMethod,
                             urlString: String,
                             headers: [String: String] = [String: String](),
                             queryParams: [String: String] = [:]) -> AnyPublisher<AsyncState<T>, Never> {
        
        let subject = CurrentValueSubject<AsyncState<T>, Never>(.loading)

        guard var urlComponents = URLComponents(string: urlString) else {
            subject.value = .failure(URLError(.badURL))
            return subject.eraseToAnyPublisher()
        }
        
        urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            subject.value = .failure(URLError(.badURL))
            return subject.eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = nil
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.setValue(HTTPContentType.applicationJSON.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                subject.value = .failure(RepositoryError.networkRequestFailed(underlyingError: error!))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                subject.value = .failure(RepositoryError.parsingFailed(details: "Unable to parse URLResponse as HTTPURLResponse: \(String(describing: response))"))
                return
            }
            
            guard case self.HTTPAcceptableCodes = httpResponse.statusCode else {
                subject.value = .failure(RepositoryError.httpError(statusCode: httpResponse.statusCode, responseCode: nil, defaultMessage: nil))
                return
            }
            
            guard let populatedData = data else {
                subject.value = .failure(RepositoryError.parsingFailed(details: "Unable to read data: \(String(describing: data))"))
                return
            }
            
            DispatchQueue.global(qos: .utility).async {
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: populatedData)
                    DispatchQueue.main.async { subject.value = .success(decoded) }
                } catch {
                    DispatchQueue.main.async { subject.value = .failure(error) }
                }
            }
        }.resume()
        
        return subject.eraseToAnyPublisher()
    }
}
