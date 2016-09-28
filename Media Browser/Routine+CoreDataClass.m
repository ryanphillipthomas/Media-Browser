//
//  Routine+CoreDataClass.m
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "Routine+CoreDataClass.h"
#import "Location+CoreDataClass.h"

#import "Photo+CoreDataClass.h"
#import "Video+CoreDataClass.h"

@implementation Routine

+ (void)createOrUpdateObjectName:(NSString *)name
                            date:(NSDate *)date
                       routineID:(NSString *)routineID
                      locationID:(NSString *)locationID
                    thumbnailURL:(NSString *)thumbnailURL
                      completion:(MBSaveCompletionBlock)completionBlock
{
    __block Routine *routine;
    __block Routine *fetchedRoutine;
    
    __block Location *location;
    __block Location *fetchedLocation;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        @autoreleasepool {
            
            fetchedRoutine = [[Routine MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"routineID = %@", routineID] inContext:localContext] firstObject];
            
            fetchedLocation = [[Location MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"locationID = %@", locationID] inContext:localContext] firstObject];

            
            if (!fetchedRoutine) {
                routine = [Routine MR_createEntityInContext:localContext];
            } else {
                routine = [fetchedRoutine MR_inContext:localContext];
            }
            
            if (!fetchedLocation) {
                location = [Location MR_createEntityInContext:localContext];
            } else {
                location = [fetchedLocation MR_inContext:localContext];
            }
            
            routine.routineID = routineID;
            routine.name = name;
            routine.thumbnailURL = thumbnailURL;
            routine.date = date;
            
            if (nil == routine.location) {
                [routine setLocation:location];
            }
        }
        
    } completion:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(),^{
            if (completionBlock != nil) completionBlock(YES, nil, nil);
        });
    }];
}

+ (void)deleteObjectWithRoutineID:(NSString *)routineID
                       completion:(MBSaveCompletionBlock)completionBlock
{
    __block Routine *routineToDelete;
    __block Routine *fetchedRoutineToDelete;
    
    if (routineID) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            @autoreleasepool {
                fetchedRoutineToDelete = [[Routine MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"routineID = %@", routineID] inContext:localContext] firstObject];
                if (fetchedRoutineToDelete) {
                    routineToDelete = [localContext objectWithID:fetchedRoutineToDelete.objectID];
                    [routineToDelete MR_deleteEntityInContext:localContext];
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
