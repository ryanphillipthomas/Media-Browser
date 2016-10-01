//
//  RoutinesViewController.m
//  Media Browser
//
//  Created by Ryan Thomas on 9/27/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "RoutinesTableViewController.h"
#import "MediaCollectionViewController.h"

@interface RoutinesTableViewController ()
@property (nonatomic, strong) Location *selectedLocation;
@end

@implementation RoutinesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSelectedLocationFromDefaults];
    
    [self refreshData];


    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                   target:self
                                                                                   action:@selector(refreshData)];
    
    UIBarButtonItem *locationButton = [[UIBarButtonItem alloc] initWithTitle:@"Locations"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(chooseLocation)];
    self.navigationItem.leftBarButtonItem = locationButton;
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    self.mediaCollectionViewController = (MediaCollectionViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    
    self.fetchedResultsController = nil;
    [self fetch];
}

- (void)refreshData
{
    [self performSelectorInBackground:@selector(refreshFTPData) withObject:nil];
}

- (void)chooseLocation
{
    [self performSegueWithIdentifier:@"showLocations" sender:nil];
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
    [[self ftpData] getAllRoutinesForLocationPath:self.selectedLocation.locationPath locationID:self.selectedLocation.locationID withCompletion:^(BOOL performed) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        //todo check items for count and display empty status if applicable
    }];
}

- (void)loadSelectedLocationFromDefaults
{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedLocationID"];
    NSManagedObjectContext *context = [[MagicalRecordStack defaultStack] context];
    self.selectedLocation = [[Location MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"locationID == %@", savedValue] inContext:context] firstObject];
    
    [self setTitle:self.selectedLocation.name];
}

- (void)saveSelectedLocationToDefaults
{
    NSString *locationID = self.selectedLocation.locationID;
    [[NSUserDefaults standardUserDefaults] setObject:locationID forKey:@"selectedLocationID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Routine *routine = [self.fetchedResultsController objectAtIndexPath:indexPath];
        MediaCollectionViewController *controller = (MediaCollectionViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:routine];
    }
    
    if ([[segue identifier] isEqualToString:@"showLocations"]) {
        LocationsTableViewController *controller = (LocationsTableViewController *)[[segue destinationViewController] topViewController];
        [controller setDelegate:self];
    }
}

#pragma mark - Locations Delegate
- (void)didUpdateLocation:(Location *)location
{
    [self setTitle:location.name];
    self.selectedLocation = location;
    [self saveSelectedLocationToDefaults];
    [self refreshFTPData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Routine *routine = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell withRoutine:routine];
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell withRoutine:(Routine *)routine {
    cell.textLabel.text = routine.name;
}


#pragma mark - Fetched results controller

- (void)fetch {
    NSError *error = nil;
    BOOL success = [self.fetchedResultsController performFetch:&error];
    NSAssert2(success, @"Unhandled error performing fetch at LOAddTableViewController, line %d: %@", __LINE__, [error localizedDescription]);
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}


- (NSFetchedResultsController<Routine *> *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [[MagicalRecordStack defaultStack] context];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Routine" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"location.locationID == %@", self.selectedLocation.locationID];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];

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
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withRoutine:anObject];
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

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
