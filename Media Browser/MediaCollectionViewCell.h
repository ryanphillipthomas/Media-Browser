//
//  MediaCollectionViewCell.h
//  Media Browser
//
//  Created by Ryan Thomas on 9/30/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIImageView *overlayView;

@end
