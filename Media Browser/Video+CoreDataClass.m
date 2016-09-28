//
//  Video+CoreDataClass.m
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "Video+CoreDataClass.h"
#import "Routine+CoreDataClass.h"

@implementation Video

+ (void)createOrUpdateObjectName:(NSString *)name
                            date:(NSDate *)date
                         videoID:(NSString *)videoID
                       routineID:(NSString *)routineID
                        mediaURL:(NSString *)mediaURL
                      completion:(MBSaveCompletionBlock)completionBlock
{
    __block Video *video;
    __block Video *fetchedVideo;
    
    __block Routine *routine;
    __block Routine *fetchedRoutine;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        @autoreleasepool {
        
            fetchedVideo = [[Video MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"videoID = %@", videoID] inContext:localContext] firstObject];
            
            fetchedRoutine = [[Routine MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"routineID = %@", routineID] inContext:localContext] firstObject];
            
            if (!fetchedVideo) {
                video = [Video MR_createEntityInContext:localContext];
            } else {
                video = [fetchedVideo MR_inContext:localContext];
            }
            
            if (!fetchedRoutine) {
                routine = [Routine MR_createEntityInContext:localContext];
            } else {
                routine = [fetchedRoutine MR_inContext:localContext];
            }
            
            video.videoID = videoID;
            video.name = name;
            video.mediaURL = mediaURL;
            video.date = date;
            
            if (nil == video.routine) {
                [video setRoutine:routine];
            }
        }
        
    } completion:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(),^{
            if (completionBlock != nil) completionBlock(YES, nil, nil);
        });
    }];
}

+ (void)deleteObjectWithVideoID:(NSString *)videoID
                     completion:(MBSaveCompletionBlock)completionBlock
{
    __block Video *videoToDelete;
    __block Video *fetchedVideoToDelete;
    
    if (videoID) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            @autoreleasepool {
                fetchedVideoToDelete = [[Video MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"videoID = %@", videoID] inContext:localContext] firstObject];
                if (fetchedVideoToDelete) {
                    videoToDelete = [localContext objectWithID:fetchedVideoToDelete.objectID];
                    [videoToDelete MR_deleteEntityInContext:localContext];
                } else {
                    // could not delete
                    dispatch_async(dispatch_get_main_queue(),^{
                        if (completionBlock != nil) completionBlock(YES, nil, nil);
                    });
                }
            }
        } completion:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(),^{
                if (completionBlock != nil) completionBlock(success, nil, error);
            });
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(),^{
            if (completionBlock != nil) completionBlock(YES, nil, nil);
        });
    }
}

@end
