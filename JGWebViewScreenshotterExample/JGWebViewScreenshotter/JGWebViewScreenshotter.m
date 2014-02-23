//
//  JGWebViewSnapshotter.m
//  Baton
//
//  Created by Jaden Geller on 2/15/14.
//  Copyright (c) 2014 EJVDev. All rights reserved.
//

#import "JGWebViewScreenshotter.h"
#import "UIWebView+Screenshot.h"

#pragma makr - Request

CGFloat const JGSnapshotHeightFull = CGFLOAT_MAX;

@interface JGWebViewScreenshotterRequest : NSObject

@property (nonatomic) NSURL *URL;
@property (nonatomic) CGSize size;
@property (nonatomic, copy) tookScreenshot completion;

+(JGWebViewScreenshotterRequest*)requestWithURL:(NSURL*)URL size:(CGSize)size completion:(tookScreenshot)completion;

@end

@implementation JGWebViewScreenshotterRequest

+(JGWebViewScreenshotterRequest*)requestWithURL:(NSURL*)URL size:(CGSize)size completion:(tookScreenshot)completion{
    JGWebViewScreenshotterRequest *request = [[JGWebViewScreenshotterRequest alloc]init];
    request.URL = URL;
    request.size = size;
    request.completion = completion;
    
    return request;
}

@end

#pragma mark - Snapshotter

@interface JGWebViewScreenshotter ()

@property (nonatomic) UIWebView *web;
@property (nonatomic) NSMutableArray *requests;

@property (nonatomic) JGWebViewScreenshotterRequest *currentRequest;

@end

@implementation JGWebViewScreenshotter

+(JGWebViewScreenshotter*)sharedInstance{
    
    static JGWebViewScreenshotter *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JGWebViewScreenshotter alloc]init];
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
    
    if (self.currentRequest){
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

+(void)requestScreenshotWithURL:(NSURL*)URL size:(CGSize)size completion:(tookScreenshot)completion{
    [[JGWebViewScreenshotter sharedInstance] requestScreenshotWithURL:URL size:size completion:completion];
}

+(void)requestScreenshotWithURL:(NSURL*)URL width:(CGFloat)width completion:(tookScreenshot)completion{
    [[JGWebViewScreenshotter sharedInstance] requestScreenshotWithURL:URL width:width completion:completion];
}

-(void)requestScreenshotWithURL:(NSURL*)URL size:(CGSize)size completion:(tookScreenshot)completion{
    [self enqueueRequest:[JGWebViewScreenshotterRequest requestWithURL:URL size:size completion:completion]];
}

-(void)requestScreenshotWithURL:(NSURL *)URL width:(CGFloat)width completion:(tookScreenshot)completion{
    [self enqueueRequest:[JGWebViewScreenshotterRequest requestWithURL:URL size:CGSizeMake(width, JGSnapshotHeightFull) completion:completion]];
}

-(void)enqueueRequest:(JGWebViewScreenshotterRequest*)request{
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
        [self.web loadRequest:[NSURLRequest requestWithURL:self.currentRequest.URL]];
    }
}

-(void)finishCurrentRequest{
    self.currentRequest = nil;
    [self processNextRequest];
}

@end
