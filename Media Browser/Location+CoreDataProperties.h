//
//  Location+CoreDataProperties.h
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "Location+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

+ (NSFetchRequest<Location *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *locationID;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *locationPath;

@property (nullable, nonatomic, retain) NSSet<Routine *> *routines;

@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addRoutinesObject:(Routine *)value;
- (void)removeRoutinesObject:(Routine *)value;
- (void)addRoutines:(NSSet<Routine *> *)values;
- (void)removeRoutines:(NSSet<Routine *> *)values;

@end

NS_ASSUME_NONNULL_END
