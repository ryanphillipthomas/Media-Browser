//
//  Location+CoreDataProperties.m
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "Location+CoreDataProperties.h"

@implementation Location (CoreDataProperties)

+ (NSFetchRequest<Location *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Location"];
}

@dynamic locationID;
@dynamic date;
@dynamic name;
@dynamic routines;

@end
