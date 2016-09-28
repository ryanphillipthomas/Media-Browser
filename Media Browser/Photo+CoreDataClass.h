//
//  Photo+CoreDataClass.h
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>

NS_ASSUME_NONNULL_BEGIN

@interface Photo : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (void)createOrUpdateObjectName:(NSString *)name
                            date:(NSDate *)date
                         photoID:(NSString *)photoID
                       routineID:(NSString *)routineID
                        mediaURL:(NSString *)mediaURL
                      completion:(MBSaveCompletionBlock)completionBlock;

+ (void)deleteObjectWithPhotoID:(NSString *)photoID
                     completion:(MBSaveCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END

#import "Photo+CoreDataProperties.h"
