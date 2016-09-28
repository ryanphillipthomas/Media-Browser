//
//  Video+CoreDataClass.h
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>

NS_ASSUME_NONNULL_BEGIN

@interface Video : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (void)createOrUpdateObjectName:(NSString *)name
                            date:(NSDate *)date
                         videoID:(NSString *)videoID
                       routineID:(NSString *)routineID
                        mediaURL:(NSString *)mediaURL
                      completion:(MBSaveCompletionBlock)completionBlock;

+ (void)deleteObjectWithVideoID:(NSString *)videoID
                     completion:(MBSaveCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END

#import "Video+CoreDataProperties.h"
