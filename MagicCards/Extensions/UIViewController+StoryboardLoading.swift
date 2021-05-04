import UIKit

protocol UIViewControllerLoading {}

extension UIViewController : UIViewControllerLoading {}

extension UIViewControllerLoading where Self : UIViewController {
    static func loadFromStoryboard(_ storyboardNameOrNil: String? = nil) -> Self {
        let nibName = storyboardNameOrNil ?? self.className
        let storyboard = UIStoryboard(name: nibName, bundle: nil)
        return storyboard.instantiateInitialViewController() as! Self
    }
    
    fileprivate static var className: String {
        let className = "\(self)"
        let components = className.split {$0 == "."}.map ( String.init )
        return components.last!
    }
}
