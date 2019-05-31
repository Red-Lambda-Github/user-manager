//
//  LSIUser.m
//  RandomUser
//
//  Created by Spencer Curtis on 4/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

#import "LSIUser.h"

@implementation LSIUser

- (instancetype)initWithName:(NSString *)name gender:(NSString *)gender email:(NSString *)email
{
    self = [super init];
    if (self) {
        _name = [name copy];
        _gender = [gender copy];
        _email = [email copy];
    }
    return self;
}

@end

@implementation LSIUser (JSONSerialization)

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    // How do we get the values we want (to initialize an LSIUser) from this dictionary
    
    // Assume that we are parsing from the {} 0 dictionary in the JSON (not the highest level node)
    
    NSString *name = dictionary[@"name"][@"first"];
    NSString *gender = dictionary[@"gender"];
    NSString *email = dictionary[@"email"];
    
    // Write out self = [super init] and so on, or call the memberwise initializer we already made
    
    return [self initWithName:name gender:gender email:email];
}

@end
