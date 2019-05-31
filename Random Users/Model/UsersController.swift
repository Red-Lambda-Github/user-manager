import UIKit

/// A collection of users that can be queried on demand. This
/// model is not persisted beyond the application runtime.
class UsersController {
    
    static let shared = UsersController()
    private init() {}
    
    // Add a batch of users to the model, spawning thumbnails for each
    // new user
    func addUsers(_ newUsers: [User]) {
        users.append(contentsOf: newUsers)
    }
    
    private var _users: [User] = []
    private(set) var users: [User] { // Ensure atomic access
        get {
            return accessQueue.sync { _users }
        }
        set {
            accessQueue.async { self._users = newValue }
        }
    }
    private let accessQueue = DispatchQueue(label: "com.LambdaSchool.RandomUsers.UserControllerQueue")
}
