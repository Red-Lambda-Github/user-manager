import Foundation

/// A batch result from a server query
struct QueryResult: Codable {
    struct Info: Codable {
        let seed: String
        let results: Int
        let page: Int
        let version: String
    }
    let results: [User]
    let info: Info
}
