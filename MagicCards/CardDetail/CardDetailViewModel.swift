import UIKit

protocol CardDetailViewModelType {
    var name: String { get }
    var image: UIImage? { get }
}

struct CardDetailViewModel: CardDetailViewModelType {
    let name: String
    let image: UIImage?
}
