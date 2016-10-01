//
//  LocationsTableViewController.m
//  Media Browser
//
//  Created by Ryan Thomas on 9/29/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "LocationsTableViewController.h"

@interface LocationsTableViewController ()
@property (nonatomic, strong) Location *selectedLocation;
@end

@implementation LocationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSelectedLocationFromDefaults];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LocationCell"];

    [self refreshData];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                   target:self
                                                                                   action:@selector(close)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)loadSelectedLocationFromDefaults
{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedLocationID"];
    NSManagedObjectContext *context = [[MagicalRecordStack defaultStack] context];
    self.selectedLocation = [[Location MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"locationID == %@", savedValue] inContext:context] firstObject];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.fetchedResultsController = nil;
    [self fetch];
}

- (void)refreshData
{
    [self performSelectorInBackground:@selector(refreshFTPData) withObject:nil];
}

- (void)close
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //DO NOTHING
    }];
}

- (FTPObjectData *)ftpData
{
    if (!_ftpData) {
        _ftpData = [[FTPObjectData alloc] init];
    }
    
    return _ftpData;
}


- (void)refreshFTPData
{
    [[self ftpData] getAllLocations:^(BOOL performed) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        //todo check items for count and display empty status if applicable
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    Location *location = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell withLocation:location];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    Location *location = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate didUpdateLocation:location];
    self.selectedLocation = location;
    [self close];
}

- (void)configureCell:(UITableViewCell *)cell withLocation:(Location *)location {
    cell.textLabel.text = location.name;
    
    if (location == self.selectedLocation) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
}


#pragma mark - Fetched results controller

- (void)fetch {
    NSError *error = nil;
    BOOL success = [self.fetchedResultsController performFetch:&error];
    NSAssert2(success, @"Unhandled error performing fetch at LocationsTableViewContoller, line %d: %@", __LINE__, [error localizedDescription]);
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (NSFetchedResultsController<Location *> *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [[MagicalRecordStack defaultStack] context];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:context];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController *afetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:context
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
    
    afetchedResultsController.delegate = self;
    
    _fetchedResultsController = afetchedResultsController;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withLocation:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
// - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
// {
// // In the simplest, most efficient, case, reload the table view.
// [self.tableView reloadData];
// }


@end
