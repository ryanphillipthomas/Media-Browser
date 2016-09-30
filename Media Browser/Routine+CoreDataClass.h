//
//  Routine+CoreDataClass.h
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>

@class Photo, Video;

NS_ASSUME_NONNULL_BEGIN

@interface Routine : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (void)createOrUpdateObjectName:(NSString *)name
                            date:(NSDate *)date
                       routineID:(NSString *)routineID
                    routinePath:(NSString *)routinePath
                      locationID:(NSString *)locationID
                    thumbnailURL:(NSString *)thumbnailURL
                      completion:(MBSaveCompletionBlock)completionBlock;

+ (void)deleteObjectWithRoutineID:(NSString *)routineID
                       completion:(MBSaveCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END

#import "Routine+CoreDataProperties.h"
