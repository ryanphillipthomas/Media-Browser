//
//  Routine+CoreDataProperties.m
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "Routine+CoreDataProperties.h"

@implementation Routine (CoreDataProperties)

+ (NSFetchRequest<Routine *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Routine"];
}

@dynamic routineID;
@dynamic date;
@dynamic name;
@dynamic thumbnailURL;
@dynamic videos;
@dynamic photos;
@dynamic location;
@dynamic routinePath;

@end
