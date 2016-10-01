//
//  Photo+CoreDataClass.m
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "Photo+CoreDataClass.h"
#import "Routine+CoreDataClass.h"

@implementation Photo

+ (void)createOrUpdateObjectName:(NSString *)name
                            date:(NSDate *)date
                         photoID:(NSString *)photoID
                       routineID:(NSString *)routineID
                        mediaURL:(NSString *)mediaURL
                      completion:(MBSaveCompletionBlock)completionBlock
{
    __block Photo *photo;
    __block Photo *fetchedPhoto;
    
    __block Routine *routine;
    __block Routine *fetchedRoutine;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        @autoreleasepool {
            
            fetchedPhoto = [[Photo MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"photoID = %@", photoID] inContext:localContext] firstObject];
            
            fetchedRoutine = [[Routine MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"routineID = %@", routineID] inContext:localContext] firstObject];
            
            if (!fetchedPhoto) {
                photo = [Photo MR_createEntityInContext:localContext];
            } else {
                photo = [fetchedPhoto MR_inContext:localContext];
            }
            
            if (!fetchedRoutine) {
                routine = [Routine MR_createEntityInContext:localContext];
            } else {
                routine = [fetchedRoutine MR_inContext:localContext];
            }
            
            photo.photoID = mediaURL;
            photo.name = name;
            photo.mediaURL = mediaURL;
            photo.date = date;
            
            if (nil == photo.routine) {
                [photo setRoutine:routine];
            }
        }
        
    } completion:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(),^{
            if (completionBlock != nil) completionBlock(YES, nil, nil);
        });
    }];
}

+ (void)deleteObjectWithPhotoID:(NSString *)photoID
                     completion:(MBSaveCompletionBlock)completionBlock
{
    __block Photo *photoToDelete;
    __block Photo *fetchedPhotoToDelete;
    
    if (photoID) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            @autoreleasepool {
                fetchedPhotoToDelete = [[Photo MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"photoID = %@", photoID] inContext:localContext] firstObject];
                if (fetchedPhotoToDelete) {
                    photoToDelete = [localContext objectWithID:fetchedPhotoToDelete.objectID];
                    [photoToDelete MR_deleteEntityInContext:localContext];
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
