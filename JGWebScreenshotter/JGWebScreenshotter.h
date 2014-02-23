//
//  JGWebScreenshotter.h
//
//  Created by Jaden Geller on 2/23/14.
//  Copyright (c) 2014 Jaden Geller. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^tookScreenshot)(UIImage *screenshot);

@interface JGWebScreenshotter : NSObject <UIWebViewDelegate>

// Convenience method that automatically executes on the shared instance
+(void)requestScreenshotWithURL:(NSURL*)URL size:(CGSize)size completion:(tookScreenshot)completion;
+(void)requestScreenshotWithURL:(NSURL*)URL width:(CGFloat)width completion:(tookScreenshot)completion;

+(JGWebScreenshotter*)sharedInstance;
-(void)requestScreenshotWithURL:(NSURL*)URL size:(CGSize)size completion:(tookScreenshot)completion;
-(void)requestScreenshotWithURL:(NSURL*)URL width:(CGFloat)width completion:(tookScreenshot)completion;

@end
