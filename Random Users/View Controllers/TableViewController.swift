import UIKit

class TableViewController: UITableViewController {
    
    static let reuseIdentifier = "cell"
    
    // MARK: - Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UsersController.shared.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewController.reuseIdentifier)
            else { fatalError("Inconstructable cell") }
        
        let user = UsersController.shared.users[indexPath.row]
        
        cell.textLabel?.text = "\(user.name)"
        cell.imageView?.image = UIImage(named: "Lambda_Logo_Full")!
        cell.imageView?.contentMode = .scaleAspectFit
        if let cachedThumbnail = ImageCache.shared[thumbnail: user] {
            cell.imageView?.image = cachedThumbnail
        } else {
            
            let imageFetchOperation = FetchImageOperation(user: user, imageType: .thumbnail)
            imageFetchOperation.completionBlock = { [weak imageFetchOp = imageFetchOperation] in
                ImageCache.shared[thumbnail: user] = imageFetchOp?.result
            }
            let updateUIOp = BlockOperation {
                defer { self.imageFetchOperations.removeValue(forKey: user) }
                
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                    currentIndexPath != indexPath {
                    print("Got image for now-reused cell")
                    return // Cell has been reused
                }
                
                cell.imageView?.image = imageFetchOperation.result
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
            updateUIOp.addDependency(imageFetchOperation)
            fetchQueue.addOperation(imageFetchOperation)
            OperationQueue.main.addOperation(updateUIOp)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = UsersController.shared.users[indexPath.row]
        imageFetchOperations[user]?.cancel()
    }
    
    // MARK: - Adding Data
    
    // Perform a batch add of n users. Adjust n as desired by
    // setting the count parameter for `fetchUsers`
    @IBAction func addUsers(_ sender: Any) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let fetchOperation = FetchUsersOperation(numberOfUsers: 1000)
        let updateUIOperation = BlockOperation {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            guard let users = fetchOperation.results else { return }
            UsersController.shared.addUsers(users)
            self.tableView.reloadData()
        }
        updateUIOperation.addDependency(fetchOperation)
        
        fetchQueue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(updateUIOperation)
    }
    
    // MARK: - Segue Preparation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItemDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow
                else { return }
            let detailVC = segue.destination as! UserDisplayController
            
            // Fetch user
            detailVC.user = UsersController.shared.users[indexPath.row]
        }
    }
    
    // MARK: - Properties
    
    private let fetchQueue = OperationQueue()
    private var imageFetchOperations = [User : Operation]()
}

