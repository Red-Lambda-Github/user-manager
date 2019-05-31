//
//  FetchImageOperation.swift
//  Astronomy
//
//  Created by Andrew R Madsen on 9/5/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

class FetchUsersOperation: ConcurrentOperation {
    
    init(numberOfUsers: Int, session: URLSession = URLSession.shared) {
        self.numberOfUsers = numberOfUsers
        self.session = session
        super.init()
    }
 
    override func start() {
        if isCancelled { return }
        
        state = .isExecuting
        
        let url = urlForFetching(numberOfUsers: numberOfUsers)
        let task = session.dataTask(with: url) { (data, response, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching data for: \(error)")
                self.error = error
                return
            }
            
            guard let data = data else {
                NSLog("Received no data")
                return
            }
            
            do {
                let queryResult = try JSONDecoder().decode(QueryResult.self, from: data)
                self.results = queryResult.results
            } catch {
                NSLog("Error decoding users: \(error)")
                self.error = error
            }
        }
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
    // MARK: - Private
    
    private func urlForFetching(numberOfUsers: Int) -> URL {
        /// The API endpoint, which should add a batch count using `results=n`
        let endPoint = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture")!
        var components = URLComponents(url: endPoint, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "format", value: "json"),
        URLQueryItem(name: "inc", value: "name,email,phone,picture"),
        URLQueryItem(name: "results", value: String(numberOfUsers))]
        return components.url!
    }
    
    // MARK: Properties
    
    private let numberOfUsers: Int
    private let session: URLSession
    
    private(set) var results: [User]?
    private(set) var error: Error?
    
    private var dataTask: URLSessionDataTask?
}
