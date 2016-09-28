//
//  Location+CoreDataClass.h
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>

@class Routine;

NS_ASSUME_NONNULL_BEGIN

@interface Location : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (void)createOrUpdateObjectName:(NSString *)name
                            date:(NSDate *)date
                      locationID:(NSString *)locationID
                      completion:(MBSaveCompletionBlock)completionBlock;

+ (void)deleteObjectWithLocationID:(NSString *)locationID
                        completion:(MBSaveCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END

#import "Location+CoreDataProperties.h"
