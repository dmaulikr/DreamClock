//
//  DreamStore.m
//  DreamClock
//
//  Created by Thomas Thornton on 12/2/14.
//  Copyright (c) 2014 ThomasApps. All rights reserved.
//

#import "DreamStore.h"

@interface DreamStore ()

@property (nonatomic) NSMutableArray *privateDreams;

@end


@implementation DreamStore

+ (instancetype)sharedStore {
    static DreamStore *sharedStore = nil; //static = not destroyed when done executing
    
    if (!sharedStore) {
        sharedStore = [[self alloc]initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)initPrivate {
    self = [super init];
    
    if (self) {
        NSString *path = [self itemArchivePath];
        _privateDreams = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_privateDreams) {
            _privateDreams = [[NSMutableArray alloc]init];
        }
    }
    
    return self;
}

- (NSArray *)allDreams {

    return self.privateDreams;
    
}

- (Dream *)createDreamWithName:(NSString *)name duration:(NSNumber *)duration audioData:(NSData *)audioData {
    
    // need to create a dream here
    Dream *aDream = [[Dream alloc]initWithName:(NSString *)name duration:(NSNumber *)duration audioData:(NSData *)audioData];
    
    [self.privateDreams addObject:aDream];
    
    return aDream;
}

- (NSString *)itemArchivePath {
    //Make sure that the first argument is NSDocumentsDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"dreams.archive"];
}

- (void)removeDream:(Dream *)dream {
    
    [self.privateDreams removeObjectIdenticalTo:dream];
    
}

- (BOOL)saveChanges {
    NSString *path = [self itemArchivePath];
    
    //Returns yes on success
    return [NSKeyedArchiver archiveRootObject:self.privateDreams toFile:path];
}

@end
