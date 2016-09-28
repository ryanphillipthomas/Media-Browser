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

- (void)startParsingWithCompletion:(void (^)(BOOL performed))completionBlock;

@end
