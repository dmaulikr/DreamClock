//
//  DreamStore.h
//  DreamClock
//
//  Created by Thomas Thornton on 12/2/14.
//  Copyright (c) 2014 ThomasApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dream.h"

@class Dream;

@interface DreamStore : NSObject

@property (nonatomic, readonly) NSArray *allDreams; //other objects get the immutable version

+ (instancetype)sharedStore; // singleton means only one instance of this class

- (Dream *)createDreamWithName:(NSString *)name duration:(NSNumber *)duration audioData:(NSData *)audioData;
- (void)removeDream:(Dream *)dream;

- (BOOL)saveChanges;

@end
