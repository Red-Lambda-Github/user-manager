//
//  LSIUser.h
//  RandomUser
//
//  Created by Spencer Curtis on 4/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(User)
@interface LSIUser : NSObject

- (instancetype)initWithName:(NSString *)name gender:(NSString *)gender email:(NSString *)email;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *gender;
@property (nonatomic, copy, readonly) NSString *email;

@end


// I'm making a named "extension", so I know what should go in it
@interface LSIUser (JSONSerialization)

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
