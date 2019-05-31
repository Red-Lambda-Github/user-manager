import Foundation

/// A system user instance representing a unique person
/// with a name, contact info, and photo
struct User: Codable, Hashable, Equatable {
    struct Name: Codable, Hashable, Equatable {
        let title: String
        let first: String
        let last: String
    }
    
    struct Picture: Codable, Hashable, Equatable {
        let large: String
        let medium: String
        let thumbnail: String
    }
    
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
}

// MARK: - Custom String Convertible

extension User.Name: CustomStringConvertible {
    var description: String { return "\(title.capitalized) \(first.capitalized) \(last.capitalized)" }
}

extension User: CustomStringConvertible {
    var description: String {
        return "\(name)\n\(email)\n\(phone)"
    }
}

