//
//  Photo+CoreDataProperties.m
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "Photo+CoreDataProperties.h"

@implementation Photo (CoreDataProperties)

+ (NSFetchRequest<Photo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
}

@dynamic date;
@dynamic mediaURL;
@dynamic name;
@dynamic photoID;
@dynamic routine;

@end
