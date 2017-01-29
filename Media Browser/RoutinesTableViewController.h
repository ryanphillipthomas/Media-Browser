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

@class MediaCollectionViewController;

@interface RoutinesTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, LocationsTableViewControllerDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) MediaCollectionViewController *mediaCollectionViewController;
@property (strong, nonatomic) NSFetchedResultsController<Routine *> *fetchedResultsController;

@property (nonatomic, strong) FTPObjectData *ftpData;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UISearchBar * searchBar;

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic) bool isSearching;

@end

