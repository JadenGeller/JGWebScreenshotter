//
//  JGViewController.m
//  JGWebViewScreenshotterExample
//
//  Created by Jaden Geller on 2/23/14.
//  Copyright (c) 2014 Jaden Geller. All rights reserved.
//

#import "JGViewController.h"
#import "JGWebScreenshotter.h"

@interface JGViewController ()

@end

@implementation JGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // The screenshots will load in the order that they are requested
    
    [JGWebScreenshotter requestScreenshotWithURL:[NSURL URLWithString:@"http://google.com"] size:self.topImageView.frame.size completion:^(UIImage *screenshot) {
        self.topImageView.image = screenshot;
    }];
    
    [JGWebScreenshotter requestScreenshotWithURL:[NSURL URLWithString:@"http://apple.com"] size:self.bottomRightImageView.frame.size completion:^(UIImage *screenshot) {
        self.bottomRightImageView.image = screenshot;
    }];
    
    [JGWebScreenshotter requestScreenshotWithURL:[NSURL URLWithString:@"http://theverge.com"] size:self.bottomLeftImageView.frame.size completion:^(UIImage *screenshot) {
        self.bottomLeftImageView.image = screenshot;
    }];
    
    
    [JGWebScreenshotter requestScreenshotWithURL:[NSURL URLWithString:@"http://github.com"] size:self.middleRightImageView.frame.size completion:^(UIImage *screenshot) {
        self.middleRightImageView.image = screenshot;
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
