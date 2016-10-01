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

- (void)getAllRoutinesForLocationPath:(NSString *)locationPath
                           locationID:(NSString *)locationID
                       withCompletion:(void (^)(BOOL performed))completionBlock
{
    if (!locationID || !locationPath) {
        return;
    }
    
    __block NSString *rootFilePath = @"http://www.actorreplay.com/clients/video_uploader";
    __block NSInteger routineCounter = 0;
    
    _ftp = [FTPClient clientWithHost:@"ftp.actorreplay.com"
                                port:21
                            username:@"video@actorreplay.com"
                            password:@"Ryan1217!"];
    
    
    //Check For New Location Objects
    [_ftp listContentsAtPath:locationPath showHiddenFiles:NO success:^(NSArray *routineContents) {
        for (FTPHandle *routineHandle in routineContents) {
            ++routineCounter;
            
            if (routineHandle.type == FTPHandleTypeDirectory) {
                
                //Create / Update Routine Objects
                [Routine createOrUpdateObjectName:routineHandle.name
                                             date:routineHandle.modified
                                        routineID:routineHandle.path
                                      routinePath:routineHandle.path
                                       locationID:locationID
                                     thumbnailURL:@""
                                       completion:^(BOOL success, NSManagedObjectID *objectID, NSError *error) {
                                            //detect when complete
                                            if (routineCounter == routineContents.count) {
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

- (void)getAllMediaForRoutinePath:(NSString *)routinePath
                        routineID:(NSString *)routineID
                   withCompletion:(void (^)(BOOL performed))completionBlock
{
    if (!routinePath || !routineID) {
        return;
    }
    
    __block NSString *rootFilePath = @"http://www.actorreplay.com/clients/video_uploader";
    __block NSInteger mediaCounter = 0;
    
    _ftp = [FTPClient clientWithHost:@"ftp.actorreplay.com"
                                port:21
                            username:@"video@actorreplay.com"
                            password:@"Ryan1217!"];
    
    
    //Check For New Location Objects
    [_ftp listContentsAtPath:routinePath showHiddenFiles:NO success:^(NSArray *mediaContents) {
        for (FTPHandle *media in mediaContents) {
            ++mediaCounter;
            
            if (media.type == FTPHandleTypeFile) {
                
                if ([routineID rangeOfString:@"Video"].location != NSNotFound)
                {
                    //has video
                    [Video createOrUpdateObjectName:media.name
                                               date:media.modified
                                            videoID:[NSString stringWithFormat:@"%@/%@", rootFilePath, media.path]
                                          routineID:routineID
                                           mediaURL:[NSString stringWithFormat:@"%@/%@", rootFilePath, media.path]
                                         completion:^(BOOL success, NSManagedObjectID *objectID, NSError *error) {
                                             //
                                             if (mediaCounter == mediaContents.count) {
                                                 if (completionBlock != nil) completionBlock(YES);
                                             }
                                         }];
                    
                }
                
                if ([routineID rangeOfString:@"Photo"].location != NSNotFound)
                {
                    //has photos
                    [Photo createOrUpdateObjectName:media.name
                                               date:media.modified
                                            photoID:[NSString stringWithFormat:@"%@/%@", rootFilePath, media.path]
                                          routineID:routineID
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

- (void)getAllLocations:(void (^)(BOOL performed))completionBlock
{
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
                
                //Create / Update Location Objects
                [Location createOrUpdateObjectName:locationHandle.name
                                              date:locationHandle.modified
                                        locationID:locationHandle.name
                                       locationPath:locationHandle.path
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
                //Create / Update Location Objects
                [Location createOrUpdateObjectName:locationHandle.name
                                              date:locationHandle.modified
                                        locationID:locationHandle.name
                                       locationPath:locationHandle.path
                                        completion:^(BOOL success, NSManagedObjectID *objectID, NSError *error) {
                                            //detect when complete
                                            if (locationCounter == locationContents.count) {
                                                [_ftp listContentsAtHandle:locationHandle showHiddenFiles:NO success:^(NSArray *routineContents) {
                                                    for (FTPHandle *routineHandle in routineContents) {
                                                        ++routineCounter;
                                                        
                                                        if (routineHandle.type == FTPHandleTypeDirectory) {
                                                            // Do something with directory.
                                                    
                                                            //Create / Update Routine Objects
                                                            [Routine createOrUpdateObjectName:routineHandle.name
                                                                                         date:routineHandle.modified
                                                                                    routineID:routineHandle.path
                                                                                   routinePath:routineHandle.path
                                                                                   locationID:locationHandle.name
                                                                                 thumbnailURL:@""
                                                                                   completion:^(BOOL success, NSManagedObjectID *objectID, NSError *error) {
                                                                                       if (routineCounter == routineContents.count) {
                                                                                           [_ftp listContentsAtHandle:routineHandle showHiddenFiles:NO success:^(NSArray *mediaContents) {
                                                                                               for (FTPHandle *media in mediaContents) {
                                                                                                   ++mediaCounter;
                                                                                                   
                                                                                                   if (media.type == FTPHandleTypeFile) {
                                                                                                       
                                                                                                       if ([routineHandle.name rangeOfString:@"Video"].location != NSNotFound)
                                                                                                       {
                                                                                                           //has video
                                                                                                           [Video createOrUpdateObjectName:media.name
                                                                                                                                      date:media.modified
                                                                                                                                   videoID:[NSString stringWithFormat:@"%@/%@", rootFilePath, media.path]
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
                                                                                                                                   photoID:[NSString stringWithFormat:@"%@/%@", rootFilePath, media.path]
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
