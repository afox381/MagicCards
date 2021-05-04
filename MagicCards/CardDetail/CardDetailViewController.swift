import UIKit

final class CardDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    private let viewModel: CardDetailViewModelType
    
    init(viewModel: CardDetailViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.name
        imageView.image = viewModel.image
        imageView.applySurroundingShadow()
    }
}
