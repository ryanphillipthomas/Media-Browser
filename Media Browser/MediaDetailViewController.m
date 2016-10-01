//
//  MediaDetailViewController.m
//  Media Browser
//
//  Created by Ryan Thomas on 9/27/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "MediaDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@import AVFoundation;
@import AVKit;

@interface MediaDetailViewController ()
@property (nonatomic, strong) AVPlayerViewController *aPlayerController;
@end

@implementation MediaDetailViewController

- (void)configureViewForVideo {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        [self setTitle:self.detailItem.name];
        [self addVideoPlayerToView];
    }
}

- (void)configureViewForImage {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        [self setTitle:self.detailItem.name];
        [self addImagePlayerToView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    //[self configureView];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self.detailItem isKindOfClass:[Video class]]) {
        [self configureViewForVideo];
    } else if ([self.detailItem isKindOfClass:[Photo class]]) {
        [self configureViewForImage];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.aPlayerController.player pause];
}

- (void)addVideoPlayerToView
{
    NSURL *videoURL = [[NSURL alloc] initWithString:self.detailItem.mediaURL];
    AVURLAsset *asset = [AVURLAsset assetWithURL: videoURL];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
    
    // create an AVPlayer
    AVPlayer * player = [[AVPlayer alloc] initWithPlayerItem:item];
    
    // create a player view controller
    self.aPlayerController = [[AVPlayerViewController alloc] init];
    self.aPlayerController.player = player;
    [self.aPlayerController.player play];
    
    //show the view controller
    [self addChildViewController:self.aPlayerController];
    [self.videoView addSubview:self.aPlayerController.view];
    
    self.aPlayerController.view.frame = self.videoView.frame;
}

- (void)addImagePlayerToView
{
    // Here we use the new provided sd_setImageWithURL: method to load the web image
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.detailItem.mediaURL]
                      placeholderImage:[UIImage imageNamed:@"imageLoading"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(Video *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

@end
