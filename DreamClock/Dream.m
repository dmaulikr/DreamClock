//
//  Dream.m
//  DreamClock
//
//  Created by Thomas Thornton on 12/2/14.
//  Copyright (c) 2014 ThomasApps. All rights reserved.
//

#import "Dream.h"

@implementation Dream

-(instancetype)initWithName:(NSString *)name duration:(NSNumber *)duration audioData:(NSData *)audioData {
    
    self = [super init];
    
    if (self) {
        _name = name;
        _dateCreated = [[NSDate alloc]init];
        _duration = duration;
        _audioData = audioData;
    }
    return self;
}

- (void)setName:(NSString *)str {
    _name = str;
}

- (NSString *)name {
    return _name;
}

- (NSDate *)dateCreated {
    return _dateCreated;
}

- (void)setDuration:(NSNumber *)duration {
    _duration = duration;
}

- (NSNumber *)duration {
    return _duration;
}

- (NSData *)audioData {
    return _audioData;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.duration forKey:@"duration"];
    [aCoder encodeObject:self.audioData forKey:@"audioData"];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _duration = [aDecoder decodeObjectForKey:@"duration"];
        _audioData = [aDecoder decodeObjectForKey:@"audioData"];
    }
    
    return self;
}

@end
