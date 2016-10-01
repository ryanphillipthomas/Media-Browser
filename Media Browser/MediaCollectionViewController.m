//
//  MediaCollectionViewController.m
//  Media Browser
//
//  Created by Ryan Thomas on 9/30/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "MediaCollectionViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MediaCollectionViewCell.h"

#import "DetailViewController.h"

@import AVFoundation;
@import AVKit;

@interface MediaCollectionViewController ()
@property (nonatomic) BOOL shouldReloadCollectionView;
@property (nonatomic, strong) NSBlockOperation *blockOperation;
@end

@implementation MediaCollectionViewController

static NSString * const reuseIdentifier = @"MediaCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    [self loadSelectedRoutineFromDefaults];

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[MediaCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    [self refreshData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    
    self.fetchedResultsController = nil;
    [self fetch];
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        [self setTitle:self.detailItem.name];
        [self saveSelectedRoutineToDefaults];
    }
}

- (void)refreshData
{
    [self performSelectorInBackground:@selector(refreshFTPData) withObject:nil];
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
    [[self ftpData] getAllMediaForRoutinePath:self.detailItem.routinePath routineID:self.detailItem.routineID withCompletion:^(BOOL performed) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        //todo check items for count and display empty status if applicable
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSelectedRoutineFromDefaults
{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedRoutineID"];
    NSManagedObjectContext *context = [[MagicalRecordStack defaultStack] context];
    self.detailItem = [[Routine MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"routineID == %@", savedValue] inContext:context] firstObject];
    
    [self setTitle:self.detailItem.name];
}

- (void)saveSelectedRoutineToDefaults
{
    NSString *routineID = self.detailItem.routineID;
    [[NSUserDefaults standardUserDefaults] setObject:routineID forKey:@"selectedRoutineID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if ([self.detailItem.name rangeOfString:@"Video"].location != NSNotFound) {
        Video *video = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self configureCell:(MediaCollectionViewCell *)cell withVideo:video];
    } else if ([self.detailItem.name rangeOfString:@"Photo"].location != NSNotFound) {
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self configureCell:(MediaCollectionViewCell *)cell withPhoto:photo];
    }
    
    // Configure the cell
    
    return cell;
}

-(UIImage *)loadThumbNailForVideo:(Video *)video
{
    NSURL *urlVideo = [NSURL URLWithString:video.mediaURL];
    AVAsset *asset = [AVAsset assetWithURL:urlVideo];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage* thumbnail = [[UIImage alloc] initWithCGImage:imageRef scale:UIViewContentModeScaleAspectFit orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    [Video updateImage:thumbnail forVideoID:video.videoID completion:^(BOOL success, NSManagedObjectID *objectID, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    
    return thumbnail;
}

- (void)configureCell:(MediaCollectionViewCell *)cell withVideo:(Video *)video {    
    // Here we use the new provided sd_setImageWithURL: method to load the web image
    
    UIImage *image = [UIImage imageWithData:video.image];
    
    if (!image) {
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
            [self loadThumbNailForVideo:video];
        });

        image = [UIImage imageNamed:@"loadingImage"];
    }
    
    [cell.imageView setImage:image];
}

- (void)configureCell:(MediaCollectionViewCell *)cell withPhoto:(Photo *)photo {
    // Here we use the new provided sd_setImageWithURL: method to load the web image
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:photo.mediaURL]
                      placeholderImage:[UIImage imageNamed:@"loadingImage"]];
}

#pragma mark - Fetched results controller

- (void)fetch {
    NSError *error = nil;
    BOOL success = [self.fetchedResultsController performFetch:&error];
    NSAssert2(success, @"Unhandled error performing fetch at LOAddTableViewController, line %d: %@", __LINE__, [error localizedDescription]);
    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [[MagicalRecordStack defaultStack] context];
    NSString *entityName = [NSString new];
    
    if ([self.detailItem.name rangeOfString:@"Video"].location != NSNotFound) {
        entityName = @"Video";
    } else if ([self.detailItem.name rangeOfString:@"Photo"].location != NSNotFound) {
        entityName = @"Photo";
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"routine.routineID == %@", self.detailItem.routineID];
    
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
    self.shouldReloadCollectionView = NO;
    self.blockOperation = [[NSBlockOperation alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    __weak UICollectionView *collectionView = self.collectionView;
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.blockOperation addExecutionBlock:^{
                [collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeDelete: {
            [self.blockOperation addExecutionBlock:^{
                [collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeUpdate: {
            [self.blockOperation addExecutionBlock:^{
                [collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    __weak UICollectionView *collectionView = self.collectionView;
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            if ([self.collectionView numberOfSections] > 0) {
                if ([self.collectionView numberOfItemsInSection:indexPath.section] == 0) {
                    self.shouldReloadCollectionView = YES;
                } else {
                    [self.blockOperation addExecutionBlock:^{
                        [collectionView insertItemsAtIndexPaths:@[newIndexPath]];
                    }];
                }
            } else {
                self.shouldReloadCollectionView = YES;
            }
            break;
        }
            
        case NSFetchedResultsChangeDelete: {
            if ([self.collectionView numberOfItemsInSection:indexPath.section] == 1) {
                self.shouldReloadCollectionView = YES;
            } else {
                [self.blockOperation addExecutionBlock:^{
                    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
                }];
            }
            break;
        }
            
        case NSFetchedResultsChangeUpdate: {
            [self.blockOperation addExecutionBlock:^{
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeMove: {
            [self.blockOperation addExecutionBlock:^{
                [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
            }];
            break;
        }
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // Checks if we should reload the collection view to fix a bug @ http://openradar.appspot.com/12954582
    if (self.shouldReloadCollectionView) {
        [self.collectionView reloadData];
    } else {
        [self.collectionView performBatchUpdates:^{
            [self.blockOperation start];
        } completion:nil];
    }
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(Routine *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSArray *arrayOfIndexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [arrayOfIndexPaths firstObject];
        
        if ([self.detailItem.name rangeOfString:@"Video"].location != NSNotFound) {
            Video *video = [self.fetchedResultsController objectAtIndexPath:indexPath];
            DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
            [controller setDetailItem:video];
        } else if ([self.detailItem.name rangeOfString:@"Photo"].location != NSNotFound) {
            Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
            DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
            [controller setDetailItem:(Video *)photo]; //lies lies we are not a video, silence the error...
        }
    }
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
