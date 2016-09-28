//
//  MasterViewController.h
//  Media Browser
//
//  Created by Ryan Thomas on 9/27/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Media_Browser+CoreDataModel.h"
#import "FTPObjectData.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSFetchedResultsController<Location *> *fetchedResultsController;

@property (nonatomic, strong) FTPObjectData *ftpData;

@end

