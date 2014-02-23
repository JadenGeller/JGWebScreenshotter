//
//  JGViewController.h
//  JGWebViewScreenshotterExample
//
//  Created by Jaden Geller on 2/23/14.
//  Copyright (c) 2014 Jaden Geller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomRightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *middleRightImageView;

@end
