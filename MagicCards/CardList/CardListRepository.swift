import Foundation
import Combine

final class CardListRepository: Repository {
    enum Strings {
        static let pageSize: String = "10"
    }

    override init(urlSession: URLSession = URLSession.shared) {
        super.init(urlSession: urlSession)
    }

    func fetchCards(with name: String) -> AnyPublisher<AsyncState<CardList?>, Never>  {
        fetch(httpMethod: .get,
              urlString: "\(Url.base)/\(Url.v1)/\(Url.cards)",
              queryParams: ["name": name,
                            "pageSize": Strings.pageSize
              ])
    }
}
