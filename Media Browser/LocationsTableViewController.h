//
//  LocationsTableViewController.h
//  Media Browser
//
//  Created by Ryan Thomas on 9/29/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Media_Browser+CoreDataModel.h"
#import "FTPObjectData.h"
#import <MagicalRecord/MagicalRecord.h>

@protocol LocationsTableViewControllerDelegate <NSObject>
- (void)didSelectLocation:(NSString *)locationURL;
@end

@interface LocationsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) id<LocationsTableViewControllerDelegate> delegate;
@property (strong, nonatomic) NSFetchedResultsController<Location *> *fetchedResultsController;
@property (nonatomic, strong) FTPObjectData *ftpData;

@end
