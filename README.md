JGWebScreenshotter
======================

JGWebScreenshotter provides a quick, convenient, and efficient way to download screenshots of websites. UIImage representations of websites are requested from the shared instance and returned in a block. The class acts like a queue in that it downloads screenshots in a first-in-first-out order.

Here is an example of a simple request for a 300x300 screenshot of Google's homepage:

```
[JGWebScreenshotter requestScreenshotWithURL:[NSURL URLWithString:@"http://google.com"] size:CGSizeMake(300,300) completion:^(UIImage *screenshot) {
        // We got the screenshot!
}];
    
```

You can also request a full-height image of a website by just providing the width:

```
[JGWebScreenshotter requestScreenshotWithURL:[NSURL URLWithString:@"http://google.com"] width:300 completion:^(UIImage *screenshot) {
        // We got the screenshot!
}];
    
```

JGWebScreenshotter makes use of a UIWebView+Screenshot class extension that provides methods for taking screenshots (current frame of webview) and full-screenshots (current width, entire page height) of the webview.

```
UIImage *currentFrame = [myWebView screenshot];
UIImage *entirePage = [myWebView fullScreenshot];
```
