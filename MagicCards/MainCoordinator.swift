import UIKit

final class MainCoordinator: UINavigationController {
    fileprivate let launchScreenViewController = LaunchScreenViewController.loadFromStoryboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "M:TG Cards"
        setup()
    }
    
    private func setup() {
        let viewModel = CardListViewModel(cardListRepository: CardListRepository(), cardName: "nissa")
        let controller = CardListViewController(viewModel: viewModel)
        controller.delegate = self
        viewControllers = [controller]
    }
}

extension MainCoordinator: CardListViewControllerDelegate {
    func cardListViewController(_ cardListViewController: CardListViewController, didSelect card: Card, image: UIImage?) {
        let viewModel = CardDetailViewModel(name: card.name, image: image)
        let controller = CardDetailViewController(viewModel: viewModel)
        pushViewController(controller, animated: true)
    }
}
