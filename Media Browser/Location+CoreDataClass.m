//
//  Location+CoreDataClass.m
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "Location+CoreDataClass.h"
#import "Routine+CoreDataClass.h"

@implementation Location

+ (void)createOrUpdateObjectName:(NSString *)name
                            date:(NSDate *)date
                      locationID:(NSString *)locationID
                    locationPath:(NSString *)locationPath
                      completion:(MBSaveCompletionBlock)completionBlock
{
    __block Location *location;
    __block Location *fetchedLocation;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        @autoreleasepool {
            
            fetchedLocation = [[Location MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"locationID = %@", locationID] inContext:localContext] firstObject];
            
            if (!fetchedLocation) {
                location = [Location MR_createEntityInContext:localContext];
            } else {
                location = [fetchedLocation MR_inContext:localContext];
            }
            
            location.locationID = locationID;
            location.locationPath = locationPath;
            location.name = name;
            location.date = date;
        }
        
    } completion:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(),^{
            if (completionBlock != nil) completionBlock(YES, nil, nil);
        });
    }];
}

+ (void)deleteObjectWithLocationID:(NSString *)locationID
                        completion:(MBSaveCompletionBlock)completionBlock
{
    __block Location *locationToDelete;
    __block Location *fetchedLocationToDelete;
    
    if (locationID) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            @autoreleasepool {
                fetchedLocationToDelete = [[Routine MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"locationID = %@", locationID] inContext:localContext] firstObject];
                if (fetchedLocationToDelete) {
                    locationToDelete = [localContext objectWithID:fetchedLocationToDelete.objectID];
                    [locationToDelete MR_deleteEntityInContext:localContext];
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
