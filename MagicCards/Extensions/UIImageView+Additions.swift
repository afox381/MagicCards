import UIKit

extension UIImageView {
    private static var imageCache = NSCache<NSURL, UIImage>()
    
    public func image(fromUrl url: URL) {
        if let image = UIImageView.imageCache.object(forKey: url as NSURL) {
            self.image = image
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else { return }
            DispatchQueue.main.async {
                guard let data = data, let image = UIImage(data: data) else { return }
                self.image = image
                UIImageView.imageCache.setObject(image, forKey: url as NSURL)
            }
        }.resume()
    }
}
