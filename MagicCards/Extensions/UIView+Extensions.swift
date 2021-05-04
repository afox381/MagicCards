import UIKit

extension UIView {
    @discardableResult
    func applySurroundingShadow() -> UIView {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 8
        return self
    }
}
