//
//  FTPObjectData.m
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "FTPObjectData.h"
#import "Location+CoreDataClass.h"
#import "Routine+CoreDataClass.h"
#import "Video+CoreDataClass.h"
#import "Photo+CoreDataClass.h"

@implementation FTPObjectData

- (void)getAllLocations:(void (^)(BOOL performed))completionBlock
{
    ///good for testing but not for deployment
    __block NSString *rootFilePath = @"http://www.actorreplay.com/clients/video_uploader";
    __block NSInteger locationCounter = 0;
    
    _ftp = [FTPClient clientWithHost:@"ftp.actorreplay.com"
                                port:21
                            username:@"video@actorreplay.com"
                            password:@"Ryan1217!"];
    
    
    //Check For New Location Objects
    [_ftp listContentsAtPath:@"/" showHiddenFiles:NO success:^(NSArray *locationContents) {
        for (FTPHandle *locationHandle in locationContents) {
            ++locationCounter;
            
            if (locationHandle.type == FTPHandleTypeDirectory) {
                // Do something with directory.
                NSLog(@"Location Name: %@", locationHandle.name);
                
                //Create / Update Location Objects
                [Location createOrUpdateObjectName:locationHandle.name
                                              date:locationHandle.modified
                                        locationID:locationHandle.name
                                        completion:^(BOOL success, NSManagedObjectID *objectID, NSError *error) {
                                            //detect when complete
                                            if (locationCounter == locationContents.count) {
                                                if (completionBlock != nil) completionBlock(YES);
                                            }

                                        }];
            }
        }
        
    } failure:^(NSError *error) {
        // Display error...
        if (completionBlock != nil) completionBlock(YES);
    }];
}


//**

- (void)getAllData:(void (^)(BOOL performed))completionBlock
{
    ///good for testing but not for deployment
    __block NSString *rootFilePath = @"http://www.actorreplay.com/clients/video_uploader";
    __block NSInteger locationCounter = 0;
    __block NSInteger routineCounter = 0;
    __block NSInteger mediaCounter = 0;

    _ftp = [FTPClient clientWithHost:@"ftp.actorreplay.com"
                                port:21
                            username:@"video@actorreplay.com"
                            password:@"Ryan1217!"];
    
    
    //Check For New Location Objects
    [_ftp listContentsAtPath:@"/" showHiddenFiles:NO success:^(NSArray *locationContents) {
        for (FTPHandle *locationHandle in locationContents) {
            ++locationCounter;

            if (locationHandle.type == FTPHandleTypeDirectory) {
                // Do something with directory.
                NSLog(@"Location Name: %@", locationHandle.name);
                
                //Create / Update Location Objects
                [Location createOrUpdateObjectName:locationHandle.name
                                              date:locationHandle.modified
                                        locationID:locationHandle.name
                                        completion:^(BOOL success, NSManagedObjectID *objectID, NSError *error) {
                                            //detect when complete
                                            if (locationCounter == locationContents.count) {
                                                [_ftp listContentsAtHandle:locationHandle showHiddenFiles:NO success:^(NSArray *routineContents) {
                                                    for (FTPHandle *routineHandle in routineContents) {
                                                        ++routineCounter;
                                                        
                                                        if (routineHandle.type == FTPHandleTypeDirectory) {
                                                            // Do something with directory.
                                                    
                                                            NSLog(@"Routine Name: %@", routineHandle.name);
                                                            NSLog(@"Location Name: %@", locationHandle.name);

                                                            //Create / Update Routine Objects
                                                            [Routine createOrUpdateObjectName:routineHandle.name
                                                                                         date:routineHandle.modified
                                                                                    routineID:routineHandle.name
                                                                                   locationID:locationHandle.name
                                                                                 thumbnailURL:@""
                                                                                   completion:^(BOOL success, NSManagedObjectID *objectID, NSError *error) {
                                                                                       if (routineCounter == routineContents.count) {
                                                                                           [_ftp listContentsAtHandle:routineHandle showHiddenFiles:NO success:^(NSArray *mediaContents) {
                                                                                               for (FTPHandle *media in mediaContents) {
                                                                                                   ++mediaCounter;
                                                                                                   
                                                                                                   if (media.type == FTPHandleTypeFile) {
                                                                                                       
                                                                                                       NSLog(@"Media Name: %@", media.name);

                                                                                                       if ([routineHandle.name rangeOfString:@"Video"].location != NSNotFound)
                                                                                                       {
                                                                                                           //has video
                                                                                                           [Video createOrUpdateObjectName:media.name
                                                                                                                                      date:media.modified
                                                                                                                                   videoID:media.name
                                                                                                                                 routineID:routineHandle.name
                                                                                                                                  mediaURL:[NSString stringWithFormat:@"%@/%@", rootFilePath, media.path]
                                                                                                                                completion:^(BOOL success, NSManagedObjectID *objectID, NSError *error) {
                                                                                                                                    //
                                                                                                                                    if (mediaCounter == mediaContents.count) {
                                                                                                                                        if (completionBlock != nil) completionBlock(YES);
                                                                                                                                    }
                                                                                                                                }];
                                                                                                        
                                                                                                       }
                                                                                                       
                                                                                                       if ([routineHandle.name rangeOfString:@"Photo"].location != NSNotFound)
                                                                                                       {
                                                                                                           //has photos
                                                                                                           [Photo createOrUpdateObjectName:media.name
                                                                                                                                      date:media.modified
                                                                                                                                   photoID:media.name
                                                                                                                                 routineID:routineHandle.name
                                                                                                                                  mediaURL:[NSString stringWithFormat:@"%@/%@", rootFilePath, media.path]
                                                                                                                                completion:^(BOOL success, NSManagedObjectID *objectID, NSError *error) {
                                                                                                                                    //
                                                                                                                                    if (mediaCounter == mediaContents.count) {
                                                                                                                                        if (completionBlock != nil) completionBlock(YES);
                                                                                                                                    }
                                                                                                                                }];
                                                                                                       }
                                                                                                   }
                                                                                               }
                                                                                           } failure:^(NSError *error) {
                                                                                               // Display error...
                                                                                               if (completionBlock != nil) completionBlock(YES);
                                                                                           }];
                                                                                       }
                                                                                   }];
                                                        }

                                                    }
                                                } failure:^(NSError *error) {
                                                    // Display error...
                                                    if (completionBlock != nil) completionBlock(YES);
                                                }];
                                            }
                                        }];
            }
        }
    } failure:^(NSError *error) {
        // Display error...
        if (completionBlock != nil) completionBlock(YES);
    }];
}

@end
