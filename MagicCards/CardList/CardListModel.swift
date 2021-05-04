import Foundation

struct CardList: Codable {
    let cards: [Card]
}

struct Card: Codable {
    let name: String
    let setName: String
    let type: String
    let imageUrl: String?
}

extension CardList {
    struct NetworkResponse: Codable {
        var result: CardList
    }
}
