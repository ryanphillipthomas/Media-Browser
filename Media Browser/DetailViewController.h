//
//  DetailViewController.h
//  Media Browser
//
//  Created by Ryan Thomas on 9/27/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Media_Browser+CoreDataModel.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Routine *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

