//
//  Routine+CoreDataProperties.h
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "Routine+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Routine (CoreDataProperties)

+ (NSFetchRequest<Routine *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *routineID;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *thumbnailURL;
@property (nullable, nonatomic, retain) NSSet<Video *> *videos;
@property (nullable, nonatomic, retain) NSSet<Photo *> *photos;
@property (nullable, nonatomic, retain) NSManagedObject *location;

@end

@interface Routine (CoreDataGeneratedAccessors)

- (void)addVideosObject:(Video *)value;
- (void)removeVideosObject:(Video *)value;
- (void)addVideos:(NSSet<Video *> *)values;
- (void)removeVideos:(NSSet<Video *> *)values;

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet<Photo *> *)values;
- (void)removePhotos:(NSSet<Photo *> *)values;

@end

NS_ASSUME_NONNULL_END
