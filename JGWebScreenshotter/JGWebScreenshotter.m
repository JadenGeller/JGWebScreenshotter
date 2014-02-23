//
//  JGWebScreenshotter.m
//
//  Created by Jaden Geller on 2/23/14.
//  Copyright (c) 2014 Jaden Geller. All rights reserved.
//

#import "JGWebScreenshotter.h"
#import "UIWebView+Screenshot.h"

#pragma makr - Request

CGFloat const JGSnapshotHeightFull = CGFLOAT_MAX;

@interface JGWebScreenshotterRequest : NSObject

@property (nonatomic) NSURL *URL;
@property (nonatomic) CGSize size;
@property (nonatomic, copy) tookScreenshot completion;

+(JGWebScreenshotterRequest*)requestWithURL:(NSURL*)URL size:(CGSize)size completion:(tookScreenshot)completion;

@end

@implementation JGWebScreenshotterRequest

+(JGWebScreenshotterRequest*)requestWithURL:(NSURL*)URL size:(CGSize)size completion:(tookScreenshot)completion{
    JGWebScreenshotterRequest *request = [[JGWebScreenshotterRequest alloc]init];
    request.URL = URL;
    request.size = size;
    request.completion = completion;
    
    return request;
}

@end

#pragma mark - Snapshotter

@interface JGWebScreenshotter ()

@property (nonatomic) UIWebView *web;
@property (nonatomic) NSMutableArray *requests;
@property (nonatomic) NSInteger loadCounter;

@property (nonatomic) JGWebScreenshotterRequest *currentRequest;

@end

@implementation JGWebScreenshotter

+(JGWebScreenshotter*)sharedInstance{
    
    static JGWebScreenshotter *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JGWebScreenshotter alloc]init];
    });
    
    return sharedInstance;
}

-(id)init{
    self = [super init];
    if (self) {
        _requests = [NSMutableArray array];

    }
    return self;
}

-(void)resetWebView{
    _web = [[UIWebView alloc]init];
    _web.delegate = self;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.loadCounter--;
    
    if (self.currentRequest && self.loadCounter == 0){
        UIImage *screenshot = (self.currentRequest.size.height == JGSnapshotHeightFull) ? webView.fullScreenshot : webView.screenshot;
        self.currentRequest.completion(screenshot);
        
        self.web = nil;

        [self finishCurrentRequest];
    }
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (self.currentRequest){
        NSLog(@"Web snapshot error for URL: %@ with error: %@", self.currentRequest.URL, error);
        
    }
    
    [self finishCurrentRequest];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    self.loadCounter++;
}

+(void)requestScreenshotWithURL:(NSURL*)URL size:(CGSize)size completion:(tookScreenshot)completion{
    [[JGWebScreenshotter sharedInstance] requestScreenshotWithURL:URL size:size completion:completion];
}

+(void)requestScreenshotWithURL:(NSURL*)URL width:(CGFloat)width completion:(tookScreenshot)completion{
    [[JGWebScreenshotter sharedInstance] requestScreenshotWithURL:URL width:width completion:completion];
}

-(void)requestScreenshotWithURL:(NSURL*)URL size:(CGSize)size completion:(tookScreenshot)completion{
    [self enqueueRequest:[JGWebScreenshotterRequest requestWithURL:URL size:size completion:completion]];
}

-(void)requestScreenshotWithURL:(NSURL *)URL width:(CGFloat)width completion:(tookScreenshot)completion{
    [self enqueueRequest:[JGWebScreenshotterRequest requestWithURL:URL size:CGSizeMake(width, JGSnapshotHeightFull) completion:completion]];
}

-(void)enqueueRequest:(JGWebScreenshotterRequest*)request{
    [self.requests addObject:request];
    [self processNextRequest];
}

-(void)processNextRequest{
    if (self.requests.count && !self.currentRequest) {
        
        // Reset the webview to prevent previous website from making delegate callbacks
        // which continues to happen even after stopping a load
        [self resetWebView];
        
        self.currentRequest = [self.requests objectAtIndex:0];
        [self.requests removeObjectAtIndex:0];
        
        CGFloat height = (self.currentRequest.size.height == JGSnapshotHeightFull) ? 0 : self.currentRequest.size.height;
        self.web.frame = CGRectMake(0, 0, self.currentRequest.size.width, height);
        self.loadCounter == 0;
        [self.web loadRequest:[NSURLRequest requestWithURL:self.currentRequest.URL]];
    }
}

-(void)finishCurrentRequest{
    self.currentRequest = nil;
    [self processNextRequest];
}

@end
