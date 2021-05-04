import UIKit
import Combine

protocol CardListViewControllerDelegate: AnyObject {
    func cardListViewController(_ cardListViewController: CardListViewController, didSelect card: Card, image: UIImage?)
}

class CardListViewController: UIViewController {
    @IBOutlet fileprivate var collectionView: UICollectionView!
    
    enum Strings {
        static let cardListCellID: String = "cardListCellID"
    }
    
    private let viewModel: CardListViewModelType
    private var cancellables: Set<AnyCancellable> = []
    private var cardList: CardList?
    
    weak var delegate: CardListViewControllerDelegate?
    
    init(viewModel: CardListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "M:TG Nissa Card List"
        
        setupCollectionView()
        fetchCards()
    }
    
    private func setupCollectionView() {
        registerViews(for: collectionView)
    }
    
    private func fetchCards() {
        viewModel.fetchCardList()
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                switch state {
                case .loading:
                    print("Show loading screen")
                case .success(let cardList):
                    guard let cardList = cardList else {
                        self?.presentFetchError(.unexpectedResponse)
                        return
                    }
                    self?.cardList = cardList
                    self?.collectionView.reloadData()
                case .failure(let error):
                    self?.presentFetchError(error as? RepositoryError)
                case .inactive:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    func registerViews(for collectionView: UICollectionView) {
        let cellNib = UINib(nibName: String(describing: CardListCollectionViewCell.self), bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: Strings.cardListCellID)
    }
    
    private func presentFetchError(_ error: RepositoryError?) {
        let alert = UIAlertController(title: "Fetch Failed", message: "Cards failed to downlaod. Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in self.fetchCards() }))
        present(alert, animated: true, completion: nil)
    }
}

extension CardListViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardList?.cards.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cardList = cardList,
              indexPath.item < cardList.cards.count,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.cardListCellID, for: indexPath) as? CardListCollectionViewCell else {
            fatalError("Could not dequeue cell of type: \(CardListCollectionViewCell.self) with identifier: \(Strings.cardListCellID)")
        }
        cell.update(with: CardListCollectionViewCellModel(with: cardList.cards[indexPath.item]))
        return cell
    }
}

extension CardListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardListCollectionViewCell,
              let card = cardList?.cards[indexPath.item] else {
            return
        }
        
        delegate?.cardListViewController(self, didSelect: card, image: cell.loadedImage)
    }
}
