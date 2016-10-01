//
//  Video+CoreDataProperties.m
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "Video+CoreDataProperties.h"

@implementation Video (CoreDataProperties)

+ (NSFetchRequest<Video *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Video"];
}

@dynamic mediaURL;
@dynamic name;
@dynamic date;
@dynamic videoID;
@dynamic routine;
@dynamic image;

@end
