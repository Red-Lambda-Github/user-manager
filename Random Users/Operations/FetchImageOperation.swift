//
//  FetchImageOperation.swift
//  Sprint Fetch
//
//  Created by Andrew R Madsen on 9/6/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class FetchImageOperation: ConcurrentOperation {
    
    enum ImageType {
        case thumbnail
        case fullsize
    }
    
    init(user: User, imageType: ImageType, session: URLSession = URLSession.shared) {
        self.user = user
        self.imageType = imageType
        self.session = session
        super.init()
    }
    
    // MARK: - Overridden
    
    override func start() {
        if isCancelled { return }
        
        state = .isExecuting
        
        guard let url = urlForFetching(imageType: imageType, for: user) else {
            error = NSError()
            state = .isFinished
            return
        }
        
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
                self.error = NSError()
                return
            }
            
            self.result = UIImage(data: data)
        }
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
    // MARK: - Private
    
    private func urlForFetching(imageType: ImageType, for user: User) -> URL? {
        switch imageType {
        case .thumbnail:
            return URL(string: user.picture.thumbnail)
        case .fullsize:
            return URL(string: user.picture.large)
        }
    }
    
    // MARK: - Properties

    private let user: User
    private let imageType: ImageType
    private let session: URLSession
    
    private(set) var result: UIImage?
    private(set) var error: Error?
    
    private var dataTask: URLSessionDataTask?
}
