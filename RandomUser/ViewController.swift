//
//  ViewController.swift
//  RandomUser
//
//  Created by Spencer Curtis on 4/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Specify when we are observing something that we care about, rather than observing something that iOS cares about
    private var KVOContext = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add the view controller as an observer of the model controller's `user` property, so it can call updateViews() when we fetch a new user
        
        // The poster (sender) doesn't need to do anything extra in order for KVO to work.
        // We only have to add the observer manually
        
        userController.addObserver(self, forKeyPath: "user", options: [.new, .old], context: &KVOContext)
    }
    
    // This gets called for EVERY keypath, including ones WE aren't observing but iOS is.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == &KVOContext {
            // This is a change we care about
            
            DispatchQueue.main.async {
                self.updateViews()
            }
            
        } else {
            // This is someone else's change to observe. Send that to the super class for observation.
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    @IBAction func fetchRandomUser(_ sender: Any) {
        
        userController.fetchUser { }
    }
    
    private func updateViews() {
        
        guard let user = userController.user else { return }
        
        nameLabel.text = user.name
        genderLabel.text = user.gender
        emailLabel.text = user.email
    }
    
    let userController = UserController()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
}

