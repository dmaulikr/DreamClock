//
//  Dream.h
//  DreamClock
//
//  Created by Thomas Thornton on 12/2/14.
//  Copyright (c) 2014 ThomasApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dream : NSObject <NSCoding>
{
    NSString *_name;
    NSDate *_dateCreated;
    NSNumber *_duration;
    NSData *_audioData;
}

- (instancetype)initWithName:(NSString *)name duration:(NSNumber *)duration audioData:(NSData *)audioData;

- (void)setName:(NSString *)str;
- (NSString *)name;

- (NSDate *)dateCreated;

- (NSNumber *)duration;
- (void)setDuration:(NSNumber *)duration;

- (NSData *)audioData;

@end
