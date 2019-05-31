import UIKit

class UserDisplayController: UIViewController {  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let user = user, isViewLoaded else { return }
        
        nameLabel.text = "\(user.name)"
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        if let image = ImageCache.shared[user] {
            imageView.image = image
        } else {
            let imageFetchOp = FetchImageOperation(user: user, imageType: .fullsize)
            let updateUIOp = BlockOperation {
                guard user == self.user else { return }
                self.imageView.image = imageFetchOp.result
            }
            updateUIOp.addDependency(imageFetchOp)
            OperationQueue.main.addOperations([imageFetchOp, updateUIOp], waitUntilFinished: false)
        }
    }
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
}
