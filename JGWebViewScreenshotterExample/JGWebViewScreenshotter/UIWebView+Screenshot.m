//
//  UIWebView+Screenshot.m
//  Baton
//
//  Created by Jaden Geller on 2/23/14.
//  Copyright (c) 2014 EJV Dev. All rights reserved.
//

#import "UIWebView+Screenshot.h"

@implementation UIWebView (Screenshot)

-(UIImage*)screenshot{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0.0f);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}

-(UIImage*)fullScreenshot{
    CGRect frame = self.frame;
    
    CGFloat height = [self stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"].doubleValue;
    self.frame = CGRectMake(0, 0, self.frame.size.width, height);

    UIImage *screenshot = [self screenshot];
    self.frame = frame;
    
    return screenshot;

}

@end

