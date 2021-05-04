import UIKit

final class CardListCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var setNameLabel: UILabel!
    @IBOutlet private var typeLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    var loadedImage: UIImage? { imageView.image }
    
    private var viewModel: CardListCollectionViewCellModel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    public func update(with model: CardListCollectionViewCellModel) {
        nameLabel.text = model.name
        setNameLabel.text = model.setName
        typeLabel.text = model.type
        
        if let imageUrl = model.imageUrl {
            imageView.image(fromUrl: imageUrl)
        }
    }
}
