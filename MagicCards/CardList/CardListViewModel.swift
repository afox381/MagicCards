import Foundation
import Combine

protocol CardListViewModelType {
    func fetchCardList() -> AnyPublisher<AsyncState<CardList?>, Never>
}

struct CardListViewModel: CardListViewModelType {
    let cardListRepository: CardListRepository
    let cardName: String
    
    func fetchCardList() -> AnyPublisher<AsyncState<CardList?>, Never> {
        cardListRepository.fetchCards(with: cardName)
    }
}
