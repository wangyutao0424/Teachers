//
//  WBAuthorizeWebView.m
//  SinaWeiBoSDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Copyright 2011 Sina. All rights reserved.
//

#import "WBAuthorizeWebView.h"
#import <QuartzCore/QuartzCore.h> 

@interface WBAuthorizeWebView (Private)

- (void)bounceOutAnimationStopped;
- (void)bounceInAnimationStopped;
- (void)bounceNormalAnimationStopped;
- (void)allAnimationsStopped;

- (UIInterfaceOrientation)currentOrientation;
- (void)sizeToFitOrientation:(UIInterfaceOrientation)orientation;
- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation;
- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation;

- (void)addObservers;
- (void)removeObservers;
@end


@implementation WBAuthorizeWebView

@synthesize delegate,webview = _webView,indicatorView = _indicatorView;

#pragma mark - WBAuthorizeWebView Life Circle

- (id)init
{
    if (self = [super init]){
        if (!self.webview) {
            self.webview = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
            self.webview.delegate = self;
            [self.view addSubview:self.webview];
            
            self.indicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
            self.indicatorView.center = CGPointMake(160, 240);
            [self.view addSubview:self.indicatorView];
        }

    }
    return self;
}

-(void)viewDidLoad{

 
    self.title = @"新浪微博";
    self.navigationItem.leftBarButtonItem = [self backItem];
}

- (void)dealloc
{
    self.webview.delegate = nil;
    self.indicatorView = nil;
    [super dealloc];
}

#pragma mark Actions

- (void)onCloseButtonTouched:(id)sender
{
    [self hide:YES];
}

#pragma mark Orientations

- (UIInterfaceOrientation)currentOrientation
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

//- (void)sizeToFitOrientation:(UIInterfaceOrientation)orientation
//{
//    [self setTransform:CGAffineTransformIdentity];
//    
//    if (UIInterfaceOrientationIsLandscape(orientation))
//    {
//        [self.view setFrame:CGRectMake(0, 0, 480, 320)];
//        [_webView setFrame:CGRectMake(0, 0, 440, 260)];
//        [_indicatorView setCenter:CGPointMake(240, 160)];
//    }
//    else
//    {
//        [self.view setFrame:CGRectMake(0, 0, 320, 480)];
//        [webView setFrame:CGRectMake(0, 0, 280, 420)];
//        [indicatorView setCenter:CGPointMake(160, 240)];
//    }
//    
//    [self setCenter:CGPointMake(160, 240)];
//    
//    [self setTransform:[self transformForOrientation:orientation]];
//    
//    previousOrientation = orientation;
//}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation
{  
	if (orientation == UIInterfaceOrientationLandscapeLeft)
    {
		return CGAffineTransformMakeRotation(-M_PI / 2);
	}
    else if (orientation == UIInterfaceOrientationLandscapeRight)
    {
		return CGAffineTransformMakeRotation(M_PI / 2);
	}
    else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
		return CGAffineTransformMakeRotation(-M_PI);
	}
    else
    {
		return CGAffineTransformIdentity;
	}
}

- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation 
{
	if (orientation == previousOrientation)
    {
		return NO;
	}
    else
    {
		return orientation == UIInterfaceOrientationLandscapeLeft
		|| orientation == UIInterfaceOrientationLandscapeRight
		|| orientation == UIInterfaceOrientationPortrait
		|| orientation == UIInterfaceOrientationPortraitUpsideDown;
	}
    return YES;
}

#pragma mark Obeservers

- (void)addObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceOrientationDidChange:)
												 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)removeObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}


#pragma mark Animations

- (void)bounceOutAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceInAnimationStopped)];
	[UIView commitAnimations];
}

- (void)bounceInAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceNormalAnimationStopped)];
	[UIView commitAnimations];
}

- (void)bounceNormalAnimationStopped
{
    [self allAnimationsStopped];
}

- (void)allAnimationsStopped
{
    // nothing shall be done here
}

#pragma mark Dismiss

//- (void)hideAndCleanUp
//{
//    [self removeObservers];
//	[self removeFromSuperview];
//}

#pragma mark - WBAuthorizeWebView Public Methods

- (void)loadRequestWithURL:(NSURL *)url
{
    NSURLRequest *request =[NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    [_webView loadRequest:request];
}

-(IBAction)back:(id)sender
{
    [self hide:YES];
}

- (void)hide:(BOOL)animated{

    [self dismissModalViewControllerAnimated:animated];
    
}
- (void)show:(BOOL)animated
{
//    [self sizeToFitOrientation:[self currentOrientation]];
//    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//	if (!window)
//    {
//		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//	}
//  	[window addSubview:self];
//    
//    if (animated)
//    {
//        [panelView setAlpha:0];
//        CGAffineTransform transform = CGAffineTransformIdentity;
//        [panelView setTransform:CGAffineTransformScale(transform, 0.3, 0.3)];
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.2];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(bounceOutAnimationStopped)];
//        [panelView setAlpha:0.5];
//        [panelView setTransform:CGAffineTransformScale(transform, 1.1, 1.1)];
//        [UIView commitAnimations];
//    }
//    else
//    {
//        [self allAnimationsStopped];
//    }
//    
//    [self addObservers];
}

//- (void)hide:(BOOL)animated
//{
//	if (animated)
//    {
//		[UIView beginAnimations:nil context:nil];
//		[UIView setAnimationDuration:0.3];
//		[UIView setAnimationDelegate:self];
//		[UIView setAnimationDidStopSelector:@selector(hideAndCleanUp)];
//		[self setAlpha:0];
//		[UIView commitAnimations];
//	} 
//    [self hideAndCleanUp];
//}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
	[_indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
	[_indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
    [_indicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
    
    if (range.location != NSNotFound)
    {
        NSString *code = [request.URL.absoluteString substringFromIndex:range.location + range.length];
        
        if ([delegate respondsToSelector:@selector(authorizeWebView:didReceiveAuthorizeCode:)])
        {
            [delegate authorizeWebView:self didReceiveAuthorizeCode:code];
        }
    }
    
    return YES;
}

@end
