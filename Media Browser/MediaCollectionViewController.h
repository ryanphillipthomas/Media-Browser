//
//  MediaCollectionViewController.h
//  Media Browser
//
//  Created by Ryan Thomas on 9/30/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Media_Browser+CoreDataModel.h"
#import "FTPObjectData.h"
#import <MagicalRecord/MagicalRecord.h>

#import "Event+CoreDataClass.h"
#import "Routine+CoreDataClass.h"
#import "Location+CoreDataClass.h"
#import "Video+CoreDataClass.h"
#import "Photo+CoreDataClass.h"

@interface MediaCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Routine *detailItem;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) FTPObjectData *ftpData;

@end
