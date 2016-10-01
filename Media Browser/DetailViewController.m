//
//  DetailViewController.m
//  Media Browser
//
//  Created by Ryan Thomas on 9/27/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "DetailViewController.h"

@import AVFoundation;
@import AVKit;

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [NSString stringWithFormat:@"%lu", self.detailItem.photos.count];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
////    // remote file from server:
    NSURL *videoURL = [[NSURL alloc] initWithString:@"http://www.actorreplay.com/clients/video_uploader/LA/001-Video/lq_Clip_1.mp4"];
    AVURLAsset *asset = [AVURLAsset assetWithURL: videoURL];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];

    // create an AVPlayer
    AVPlayer * player = [[AVPlayer alloc] initWithPlayerItem: item];
    
    // create a player view controller
    AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
    controller.player = player;
    [player play];
    
     //show the view controller
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    controller.view.frame = self.view.frame;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(Routine *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}



@end
