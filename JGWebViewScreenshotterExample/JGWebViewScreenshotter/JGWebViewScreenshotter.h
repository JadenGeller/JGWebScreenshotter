//
//  JGWebViewSnapshotter.h
//  Baton
//
//  Created by Jaden Geller on 2/15/14.
//  Copyright (c) 2014 EJVDev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^tookScreenshot)(UIImage *screenshot);

@interface JGWebViewScreenshotter : NSObject <UIWebViewDelegate>

// Convenience method that automatically executes on the shared instance
+(void)requestScreenshotWithURL:(NSURL*)URL size:(CGSize)size completion:(tookScreenshot)completion;
+(void)requestScreenshotWithURL:(NSURL*)URL width:(CGFloat)width completion:(tookScreenshot)completion;

+(JGWebViewScreenshotter*)sharedInstance;
-(void)requestScreenshotWithURL:(NSURL*)URL size:(CGSize)size completion:(tookScreenshot)completion;
-(void)requestScreenshotWithURL:(NSURL*)URL width:(CGFloat)width completion:(tookScreenshot)completion;

@end
