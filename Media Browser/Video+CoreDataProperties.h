//
//  Video+CoreDataProperties.h
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "Video+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Video (CoreDataProperties)

+ (NSFetchRequest<Video *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *mediaURL;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *videoID;
@property (nullable, nonatomic, retain) NSManagedObject *routine;

@end

NS_ASSUME_NONNULL_END
