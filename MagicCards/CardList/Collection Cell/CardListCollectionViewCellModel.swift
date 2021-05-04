import Foundation

public struct CardListCollectionViewCellModel {
    let name: String
    let setName: String
    let type: String
    let imageUrl: URL?
    
    init(with card: Card) {
        self.name = card.name
        self.setName = card.setName
        self.type = card.type
        
        if let imageUrlString = card.imageUrl {
            self.imageUrl = URL(string: imageUrlString)
        } else {
            self.imageUrl = nil
        }
    }
}
