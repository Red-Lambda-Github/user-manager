//
//  LSIUserController.h
//  RandomUser
//
//  Created by Spencer Curtis on 4/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSIUser;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(UserController)
@interface LSIUserController : NSObject

// An array of LSIUser

@property (nonatomic, readonly, nullable) LSIUser *user;

// A method to fetch the users. This should have a completion block argument
// goshdarnblocksyntax.com is your friend.

- (void)fetchUser:(void (^)(void))completion;
// func fetchUser(completion: () -> Void

@end

NS_ASSUME_NONNULL_END
