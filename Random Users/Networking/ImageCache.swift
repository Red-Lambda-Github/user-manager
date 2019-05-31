import UIKit

/// A single shared cache system for storing thumbnails and
/// full sized images. These values are not persisted beyond
/// the current run of the application.
class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    // Return thumbnail
    subscript (thumbnail user: User) -> UIImage? {
        get {
            // Ensure atomic read of cache and thumbnailCache
            return accessQueue.sync { thumbnailCache[user] }
        }
        set {
            accessQueue.async { self.thumbnailCache[user] = newValue }
        }
    }
    
    // Return highest quality image available
    subscript (_ user: User) -> UIImage? {
        get {
            // Ensure atomic read of cache and thumbnailCache
            return accessQueue.sync { imageCache[user] }
        }
        set {
            accessQueue.async { self.imageCache[user] = newValue }
        }
    }
    
    // MARK: - Properties
        
    private var thumbnailCache: [User: UIImage] = [:]
    private var imageCache: [User: UIImage] = [:]
    
    private let accessQueue = DispatchQueue(label: "com.LambdaSchool.RandomUser.ImageCacheQueue")
}
