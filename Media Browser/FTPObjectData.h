//
//  FTPObjectData.h
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FTPKit/FTPKit.h>

@interface FTPObjectData : NSObject

@property (nonatomic, strong) FTPClient *ftp;

- (void)getAllData:(void (^)(BOOL performed))completionBlock;
- (void)getAllLocations:(void (^)(BOOL performed))completionBlock;

- (void)getAllRoutinesForLocationPath:(NSString *)locationPath
                           locationID:(NSString *)locationID
                       withCompletion:(void (^)(BOOL performed))completionBlock;

- (void)getAllMediaForRoutinePath:(NSString *)routinePath
                        routineID:(NSString *)routineID
                   withCompletion:(void (^)(BOOL performed))completionBlock;

@end
