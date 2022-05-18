//
//  WBEngine.m
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

#import "WBEngine.h"
#import "SFHFKeychainUtils.h"
#import "WBSDKGlobal.h"
#import "WBUtil.h"

#define kWBURLSchemePrefix              @"WB_"

#define kWBKeychainServiceNameSuffix    @"_WeiBoServiceName"
#define kWBKeychainUserID               @"WeiBoUserID"
#define kWBKeychainAccessToken          @"WeiBoAccessToken"
#define kWBKeychainExpireTime           @"WeiBoExpireTime"
#define kWBKeychainUserName             @"WeiBoUserName"


//SSO
#define kSinaWeiboAppAuthURL_iPhone        @"sinaweibosso://login"
#define kSinaWeiboAppAuthURL_iPad          @"sinaweibohdsso://login"


//for weibo key
#define kOAuthConsumerKey				@"4045596553"
#define kOAuthConsumerSecret			@"1d24407863cefdd0527df67892147019"
#define kSSoCallbackScheme              @"wx3495cdab10ad35d1"
#define kSinaRedirectUrl                @"http://www.taoche.com/app/iphone/"

BOOL SinaWeiboIsDeviceIPad()
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
        return YES;
        }
#endif
    return NO;
}

@interface WBEngine (Private)

- (NSString *)urlSchemeString;

- (void)saveAuthorizeDataToKeychain;
- (void)deleteAuthorizeDataInKeychain;

@end

@implementation WBEngine

@synthesize appKey;
@synthesize appSecret;
@synthesize userID;
@synthesize accessToken;
@synthesize expireTime;
@synthesize redirectURI;
@synthesize isUserExclusive;
@synthesize request;
@synthesize authorize;
@synthesize delegate;
@synthesize rootViewController;

#pragma mark - WBEngine Life Circle

DEF_SINGLETION(WBEngine);

-(id)init{

    if (self = [super init]) {
        [self initWithAppKey:kOAuthConsumerKey appSecret:kOAuthConsumerSecret ssoCallbackScheme:kSSoCallbackScheme];
        [self setRedirectURI:kSinaRedirectUrl];
    }
    return self;
}

- (void)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret ssoCallbackScheme:(NSString*)ssoScheme
{
    self.appKey = theAppKey;
    self.appSecret = theAppSecret;
    self.ssoCallbackScheme = ssoScheme;
    isUserExclusive = YES;
    
    [self readAuthorizeDataFromKeychain];
   
}

- (void)dealloc
{
    [appKey release], appKey = nil;
    [appSecret release], appSecret = nil;
    
    [userID release], userID = nil;
    [accessToken release], accessToken = nil;
    
    [redirectURI release], redirectURI = nil;
    
    [request setDelegate:nil];
    [request disconnect];
    [request release], request = nil;
    
    [authorize setDelegate:nil];
    [authorize release], authorize = nil;
    
    delegate = nil;
    rootViewController = nil;
    
    [super dealloc];
}

#pragma mark - WBEngine Private Methods

- (NSString *)urlSchemeString
{
    return [NSString stringWithFormat:@"%@%@", kWBURLSchemePrefix, @"bitauto"];
}

- (void)saveAuthorizeDataToKeychain
{
    NSString *serviceName = [[self urlSchemeString] stringByAppendingString:kWBKeychainServiceNameSuffix];
    [SFHFKeychainUtils storeUsername:kWBKeychainUserID andPassword:userID forServiceName:serviceName updateExisting:YES error:nil];
	[SFHFKeychainUtils storeUsername:kWBKeychainAccessToken andPassword:accessToken forServiceName:serviceName updateExisting:YES error:nil];
	[SFHFKeychainUtils storeUsername:kWBKeychainExpireTime andPassword:[NSString stringWithFormat:@"%lf", expireTime] forServiceName:serviceName updateExisting:YES error:nil];
    [SFHFKeychainUtils storeUsername:kWBKeychainUserName andPassword:self.userName forServiceName:serviceName updateExisting:YES error:nil];
    
//    [UICKeyChainStore setString:userID forKey:kWBKeychainUserID service:serviceName];
//    [UICKeyChainStore setString:accessToken forKey:kWBKeychainAccessToken service:serviceName];
//     [UICKeyChainStore setString:[NSString stringWithFormat:@"%lf", expireTime] forKey:kWBKeychainExpireTime service:serviceName];
}

- (void)readAuthorizeDataFromKeychain
{
    NSString *serviceName = [[self urlSchemeString] stringByAppendingString:kWBKeychainServiceNameSuffix];
    self.userID = [SFHFKeychainUtils getPasswordForUsername:kWBKeychainUserID andServiceName:serviceName error:nil];
    self.accessToken = [SFHFKeychainUtils getPasswordForUsername:kWBKeychainAccessToken andServiceName:serviceName error:nil];
    self.expireTime = [[SFHFKeychainUtils getPasswordForUsername:kWBKeychainExpireTime andServiceName:serviceName error:nil] doubleValue];
    self.userName = [SFHFKeychainUtils getPasswordForUsername:kWBKeychainUserName andServiceName:serviceName error:nil];
    
//    self.userID = [UICKeyChainStore  stringForKey:kWBKeychainUserID service:serviceName];
//    self.accessToken = [UICKeyChainStore  stringForKey:kWBKeychainAccessToken service:serviceName];
//    self.expireTime = [[UICKeyChainStore  stringForKey:kWBKeychainExpireTime service:serviceName] doubleValue];


}

- (void)deleteAuthorizeDataInKeychain
{
    self.userID = nil;
    self.accessToken = nil;
    self.expireTime = 0;
    self.userName = nil;
    
    NSString *serviceName = [[self urlSchemeString] stringByAppendingString:kWBKeychainServiceNameSuffix];
    [SFHFKeychainUtils deleteItemForUsername:kWBKeychainUserID andServiceName:serviceName error:nil];
	[SFHFKeychainUtils deleteItemForUsername:kWBKeychainAccessToken andServiceName:serviceName error:nil];
	[SFHFKeychainUtils deleteItemForUsername:kWBKeychainExpireTime andServiceName:serviceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kWBKeychainUserName andServiceName:serviceName error:nil];
    
//    [UICKeyChainStore removeItemForKey:kWBKeychainUserID service:serviceName];
//    [UICKeyChainStore removeItemForKey:kWBKeychainAccessToken service:serviceName];
//    [UICKeyChainStore removeItemForKey:kWBKeychainExpireTime service:serviceName];
}

#pragma mark - WBEngine Public Methods

#pragma mark Authorization

- (void)logIn
{
    if ([self isLoggedIn])
        {
        if ([delegate respondsToSelector:@selector(engineAlreadyLoggedIn:)])
            {
            [delegate engineAlreadyLoggedIn:self];
            }
        if (isUserExclusive)
            {
            return;
            }
        }
    
    
    ssoLoggingIn = NO;
    
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] &&
        [device isMultitaskingSupported]){
        NSDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                self.appKey, @"client_id",
                                self.redirectURI, @"redirect_uri",
                                self.ssoCallbackScheme, @"callback_uri", nil];
        
        // 先用iPad微博打开
        NSString *appAuthBaseURL = kSinaWeiboAppAuthURL_iPad;
        if (SinaWeiboIsDeviceIPad()){
            NSString *appAuthURL = [WBRequest serializeURL:appAuthBaseURL
                                                           params:params httpMethod:@"GET"];
            ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appAuthURL]];
        }
        
        // 在用iPhone微博打开
        if (!ssoLoggingIn){
            appAuthBaseURL = kSinaWeiboAppAuthURL_iPhone;
            NSString *appAuthURL = [WBRequest serializeURL:appAuthBaseURL
                                                    params:params httpMethod:@"GET"];
            ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appAuthURL]];
        }
        
    }
    
    //普通鉴权
    if (!ssoLoggingIn){
        WBAuthorize *auth = [[WBAuthorize alloc] initWithAppKey:appKey appSecret:appSecret];
        [auth setRootViewController:rootViewController];
        [auth setDelegate:self];
        self.authorize = auth;
        [auth release];
        
        if ([redirectURI length] > 0){
            [self.authorize setRedirectURI:self.redirectURI];
        }else{
            [self.authorize setRedirectURI:@"http://"];
        }
        
        [authorize startAuthorize];
    }

}

- (void)logInUsingUserID:(NSString *)theUserID password:(NSString *)thePassword
{
    self.userID = theUserID;
    
    if ([self isLoggedIn])
    {
        if ([delegate respondsToSelector:@selector(engineAlreadyLoggedIn:)])
        {
            [delegate engineAlreadyLoggedIn:self];
        }
        if (isUserExclusive)
        {
            return;
        }
    }
    
    WBAuthorize *auth = [[WBAuthorize alloc] initWithAppKey:appKey appSecret:appSecret];
    [auth setRootViewController:rootViewController];
    [auth setDelegate:self];
    self.authorize = auth;
    [auth release];
    
    if ([redirectURI length] > 0)
    {
        [authorize setRedirectURI:redirectURI];
    }
    else
    {
        [authorize setRedirectURI:@"http://"];
    }
    
    [authorize startAuthorizeUsingUserID:theUserID password:thePassword];
}

- (void)logOut
{
    [self deleteAuthorizeDataInKeychain];
    
    if ([delegate respondsToSelector:@selector(engineDidLogOut:)])
    {
        [delegate engineDidLogOut:self];
    }
}

- (BOOL)isLoggedIn
{
    //    return userID && accessToken && refreshToken;
    return userID && accessToken && (expireTime > 0);
}

- (BOOL)isAuthorizeExpired
{
    if ([[NSDate date] timeIntervalSince1970] > expireTime)
    {
        // force to log out
        [self deleteAuthorizeDataInKeychain];
        return YES;
    }
    return NO;
}

#pragma mark Request

- (void)loadRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                     postDataType:(WBRequestPostDataType)postDataType
                 httpHeaderFields:(NSDictionary *)httpHeaderFields
                      requestType:(WBRequestType)type
                
{
    // Step 1.
    // Check if the user has been logged in.
	if (![self isLoggedIn])
	{
        if ([delegate respondsToSelector:@selector(engineNotAuthorized:)])
        {
            [delegate engineNotAuthorized:self];
        }
        return;
	}
    
	// Step 2.
    // Check if the access token is expired.
    if ([self isAuthorizeExpired])
    {
        if ([delegate respondsToSelector:@selector(engineAuthorizeExpired:)])
        {
            [delegate engineAuthorizeExpired:self];
        }
        return;
    }
    
    [request disconnect];
    
    self.request = [WBRequest requestWithAccessToken:accessToken
                                                 url:[NSString stringWithFormat:@"%@%@", kWBSDKAPIDomain, methodName]
                                          httpMethod:httpMethod
                                              params:params
                                        postDataType:postDataType
                                    httpHeaderFields:httpHeaderFields
                                            delegate:self
                                         requestType:type];
	
	[request connect];
}

- (void)sendWeiBoWithText:(NSString *)text image:(UIImage *)image
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];

    //NSString *sendText = [text URLEncodedString];
    
	[params setObject:(text ? text : @"") forKey:@"status"];
	
    if (image)
    {
		[params setObject:image forKey:@"pic"];

        [self loadRequestWithMethodName:@"statuses/upload.json"
                             httpMethod:@"POST"
                                 params:params
                           postDataType:kWBRequestPostDataTypeMultipart
                       httpHeaderFields:nil
         requestType:kWBRequestNewWeiBo];
    }
    else
    {
        [self loadRequestWithMethodName:@"statuses/update.json"
                             httpMethod:@"POST"
                                 params:params
                           postDataType:kWBRequestPostDataTypeNormal
                       httpHeaderFields:nil
         requestType:kWBRequestNewWeiBo];
    }
}
-(void)getFriendShipWithId:(NSInteger)userId{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:[NSString stringWithFormat:@"%d", userId] forKey:@"target_id"];
    [self loadRequestWithMethodName:@"friendships/show.json"
                         httpMethod:@"GET"
                             params:params
                       postDataType:kWBRequestPostDataTypeNone
                   httpHeaderFields:nil
     requestType:kWBRequestGetFrienShip];
    
}

-(void)follow:(NSInteger)userId{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:[NSString stringWithFormat:@"%d",userId] forKey:@"uid"];
    [self loadRequestWithMethodName:@"friendships/create.json"
                         httpMethod:@"POST"
                             params:params
                       postDataType:kWBRequestPostDataTypeNormal
                   httpHeaderFields:nil
     requestType:kWBRequestFollow];
}

- (void)getUserNameWithId:(NSInteger)userId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:[NSString stringWithFormat:@"%d",userId] forKey:@"uid"];
    [self loadRequestWithMethodName:@"users/show.json"
                         httpMethod:@"GET"
                             params:params
                       postDataType:kWBRequestPostDataTypeNormal
                   httpHeaderFields:nil
                        requestType:kWBGetUserName];
}


#pragma mark - WBAuthorizeDelegate Methods

- (void)authorize:(WBAuthorize *)authorize didSucceedWithAccessToken:(NSString *)theAccessToken userID:(NSString *)theUserID expiresIn:(NSInteger)seconds
{
    
    if (authorize == nil) {

    }
    
    self.accessToken = theAccessToken;
    self.userID = theUserID;
    self.expireTime = [[NSDate date] timeIntervalSince1970] + seconds;
    
    [self saveAuthorizeDataToKeychain];
    
    [self getUserNameWithId:[theUserID intValue]];
    
    if ([delegate respondsToSelector:@selector(engineDidLogIn:)])
    {
        [delegate engineDidLogIn:self];
    }
}

- (void)authorize:(WBAuthorize *)authorize didFailWithError:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(engine:didFailToLogInWithError:)])
    {
        [delegate engine:self didFailToLogInWithError:error];
    }
}

#pragma mark - WBRequestDelegate Methods

- (void)request:(WBRequest *)request didFinishLoadingWithResult:(id)result requestType:(WBRequestType)type
{
    if ([delegate respondsToSelector:@selector(engine:requestDidSucceedWithResult:withRequestType:)])
        {
        if (type == kWBGetUserName) {
            self.userName = [(NSDictionary *)result objectForKey:@"name"];
            [self saveAuthorizeDataToKeychain];
            [delegate engine:self requestDidSucceedWithResult:result withRequestType:type];
        }else{
            [delegate engine:self requestDidSucceedWithResult:result withRequestType:type];
        }
        }
}

- (void)request:(WBRequest *)request didFailWithError:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(engine:requestDidFailWithError:)])
    {
        [delegate engine:self requestDidFailWithError:error];
    }
}

#pragma mark -
/**
 * @description sso回调方法，官方客户端完成sso授权后，回调唤起应用，应用中应调用此方法完成sso登录
 * @param url: 官方客户端回调给应用时传回的参数，包含认证信息等
 * @return YES
 */
- (BOOL)handleOpenURL:(NSURL *)url
{
    NSString *urlString = [url absoluteString];
    if ([urlString hasPrefix:self.ssoCallbackScheme])
        {
        if (!ssoLoggingIn)
            {
            // sso callback after user have manually opened the app
            // ignore the request
            }
        else
            {
            ssoLoggingIn = NO;
            
            if ([WBRequest getParamValueFromUrl:urlString paramName:@"sso_error_user_cancelled"])
                {
//                if ([delegate respondsToSelector:@selector(sinaweiboLogInDidCancel:)])
//                    {
//                    [delegate sinaweiboLogInDidCancel:self];
//                    }
                }
            else if ([WBRequest getParamValueFromUrl:urlString paramName:@"sso_error_invalid_params"])
                {
                if ([delegate respondsToSelector:@selector(sinaweibo:logInDidFailWithError:)])
                    {
//                    NSString *error_description = @"Invalid sso params";
//                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                                              error_description, NSLocalizedDescriptionKey, nil];
//                    NSError *error = [NSError errorWithDomain:kSinaWeiboSDKErrorDomain
//                                                         code:kSinaWeiboSDKErrorCodeSSOParamsError
//                                                     userInfo:userInfo];
//                    [delegate sinaweibo:self logInDidFailWithError:error];
                    }
                }
            else if ([WBRequest getParamValueFromUrl:urlString paramName:@"error_code"])
                {
//                NSString *error_code = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"error_code"];
//                NSString *error = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"error"];
//                NSString *error_uri = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"error_uri"];
//                NSString *error_description = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"error_description"];
//                
//                NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                                           error, @"error",
//                                           error_uri, @"error_uri",
//                                           error_code, @"error_code",
//                                           error_description, @"error_description", nil];
//                
//                [self logInDidFailWithErrorInfo:errorInfo];
                }
            else
                {
                NSString *access_token = [WBRequest getParamValueFromUrl:urlString paramName:@"access_token"];
                NSString *expires_in = [WBRequest getParamValueFromUrl:urlString paramName:@"expires_in"];
                //NSString *remind_in = [WBRequest getParamValueFromUrl:urlString paramName:@"remind_in"];
                NSString *uid = [WBRequest getParamValueFromUrl:urlString paramName:@"uid"];
                NSString *refresh_token = [WBRequest getParamValueFromUrl:urlString paramName:@"refresh_token"];
                
//                NSMutableDictionary *authInfo = [NSMutableDictionary dictionary];
//                if (access_token) [authInfo setObject:access_token forKey:@"access_token"];
//                if (expires_in) [authInfo setObject:expires_in forKey:@"expires_in"];
//                if (remind_in) [authInfo setObject:remind_in forKey:@"remind_in"];
//                if (refresh_token) [authInfo setObject:refresh_token forKey:@"refresh_token"];
//                if (uid) [authInfo setObject:uid forKey:@"uid"];
                
                [self authorize:nil didSucceedWithAccessToken:access_token userID:uid expiresIn:[expires_in integerValue]];
                }
            }
        }
    return YES;
}
- (void)applicationDidBecomeActive
{
    if (ssoLoggingIn){
        // user open the app manually
        // clean sso login state
        ssoLoggingIn = NO;
        
//       if ([delegate respondsToSelector:@selector(sinaweiboLogInDidCancel:)]){
//            [delegate sinaweiboLogInDidCancel:self];
//       }
    
    }
}
@end
