//
//  LSIUserController.m
//  RandomUser
//
//  Created by Spencer Curtis on 4/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

#import "LSIUserController.h"
#import "LSIUser.h"

@interface LSIUserController ()

@property (nonatomic, readwrite) LSIUser *user;

@end

@implementation LSIUserController

- (void)fetchUser:(void (^)(void))completion
{
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    
    // If needed, we would create URLComponents and add on to the URL
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:baseURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
        if (error) {
            NSLog(@"Error fetching random user: %@", error);
            completion();
            return;
        }
        
        if (!data) {
            NSLog(@"No data returned from data task");
            completion();
            return;
        }
        
        // Turn the data into something usable.
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (!jsonDictionary ||
            ![jsonDictionary isKindOfClass:[NSDictionary class]]) {
            NSLog(@"Dictionary does not exist, or is not a dictionary");
            completion();
            return;
        }
        
        // Parse down to the point that the initializer expects
        NSDictionary *userDictionary = [jsonDictionary[@"results"] firstObject];
        
        LSIUser *user = [[LSIUser alloc] initWithDictionary:userDictionary];
        
        self.user = user;
        
        completion();
    }];
    
    [dataTask resume];
}

static NSString * const baseURLString = @"https://randomuser.me/api/";
// let baseURL = URL(string: "someurl.com")!

@end
