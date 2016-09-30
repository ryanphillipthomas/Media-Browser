//
//  RoutinesTableViewController.h
//  Media Browser
//
//  Created by Ryan Thomas on 9/27/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Media_Browser+CoreDataModel.h"
#import "FTPObjectData.h"
#import <MagicalRecord/MagicalRecord.h>
#import "LocationsTableViewController.h"

@class DetailViewController;

@interface RoutinesTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, LocationsTableViewControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSFetchedResultsController<Routine *> *fetchedResultsController;

@property (nonatomic, strong) FTPObjectData *ftpData;

@end

