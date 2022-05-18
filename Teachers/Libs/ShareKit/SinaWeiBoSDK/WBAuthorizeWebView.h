//
//  WBAuthorizeWebView.h
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

#import <Foundation/Foundation.h>
#import "CustomViewController.h"

@class WBAuthorizeWebView;

@protocol WBAuthorizeWebViewDelegate <NSObject>

- (void)authorizeWebView:(WBAuthorizeWebView *)webView didReceiveAuthorizeCode:(NSString *)code;

@end

@interface WBAuthorizeWebView : CustomViewController <UIWebViewDelegate>
{
    
    UIActivityIndicatorView *_indicatorView;
	UIWebView *_webView;
    
    UIInterfaceOrientation previousOrientation;
    
    id<WBAuthorizeWebViewDelegate> delegate;
}

@property (nonatomic, assign) id<WBAuthorizeWebViewDelegate> delegate;
@property (nonatomic,retain) UIWebView *webview;
@property (nonatomic,retain) UIActivityIndicatorView *indicatorView;

- (void)loadRequestWithURL:(NSURL *)url;

- (void)hide:(BOOL)animated;

@end