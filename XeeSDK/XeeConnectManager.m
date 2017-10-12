/*
 * Copyright 2016 Eliocity
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "XeeConnectManager.h"
#import "Xee.h"

@interface XeeConnectManager ()

@property(nonatomic, strong) UIWebView *embeddedWV;

@end

@implementation XeeConnectManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *json = [[NSUserDefaults standardUserDefaults] objectForKey:@"XeeSDKInternalAccessToken"];
        if(json)
            _accessToken = [[XeeAccessToken alloc] initWithJSON:json];
    }
    return self;
}

-(void)showWebViewInView:(UIView *)view WithURL:(NSURL *)url {
    self.embeddedWV = [[UIWebView alloc] init];
    self.embeddedWV.delegate = self;
    CGRect frame = view.bounds;
    frame.origin.y = frame.size.height;
    self.embeddedWV.frame = frame;
    frame.origin.y = 0;
    [self.embeddedWV loadRequest:[NSURLRequest requestWithURL:url]];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(8.0, 28.0, frame.size.width / 4.0, 40.0)];
    [cancelButton setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor whiteColor]];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.embeddedWV addSubview:cancelButton];
    [view addSubview:self.embeddedWV];
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.embeddedWV.frame = frame;
    } completion:nil];
}

-(void)cancel {
    CGRect frame = self.embeddedWV.frame;
    frame.origin.y = frame.size.height;
    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.embeddedWV.frame = frame;
    } completion:^(BOOL finished) {
        [self.embeddedWV removeFromSuperview];
        [self.delegate connectManagerDidCancel:self];
    }];
}

-(void)createAccount {
    [self showRegisterPage];
}

-(void)connect {
    // if there's an access token
    if(_accessToken) {
        [Xee log:@"token already exists, try to refresh it"];
        // try to refresh the access token
        [self refreshToken:^(XeeAccessToken *accessToken, NSError *error) {
            if(!error) {
                [Xee log:@"new token is %@", accessToken];
                // got a new access token, call the handler directly
                if(accessToken)
                    [self.delegate connectManager:self didSuccess:accessToken];
                // else, show the auth page in safari
                else {
                    [self showAuthPage];
                }
            } else {
                [Xee log:@"error refreshing the token"];
                [self.delegate connectManager:self didFailWithError:error];
            }
        }];
    // else show the auth page in safari
    } else {
        [self showAuthPage];
    }
}

-(void)showRegisterPage {
    [Xee log:@"show register page"];
    
    NSString *urlEncodedScopes = [self createURLEncodedStringWithArray:_config.scopes];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@auth/register?client_id=%@&redirect_uri=%@&scope=%@", self.config.environmentURLString, _config.clientID, _config.redirectURI, urlEncodedScopes]];
    
    UIView *view = [self.delegate connectManagerViewForSignUp];
    [self showWebViewInView:view WithURL:url];
}

-(void)showAuthPage {
    [Xee log:@"show auth page"];
    
    NSString *urlEncodedScopes = [self createURLEncodedStringWithArray:_config.scopes];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@auth/auth?client_id=%@&redirect_uri=%@&scope=%@", self.config.environmentURLString, _config.clientID, _config.redirectURI, urlEncodedScopes]];
    
    UIView *view = [self.delegate connectManagerViewForLogin];
    [self showWebViewInView:view WithURL:url];
}

-(NSString*)createURLEncodedStringWithArray:(NSArray*)array {
    NSString *urlEncoded = @"";
    int i = 0;
    for(NSString *string in array) {
        urlEncoded = [urlEncoded stringByAppendingString:[NSString stringWithFormat:@"%@%@", string, i == array.count - 1 ? @"" : @" "]];
        i++;
    }
    urlEncoded = [urlEncoded stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlEncoded;
}

-(void)openURL:(NSURL*)url {
    CGRect frame = self.embeddedWV.frame;
    frame.origin.y = frame.size.height;
    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.embeddedWV.frame = frame;
    } completion:^(BOOL finished) {
        [self.embeddedWV removeFromSuperview];
        // gete the code from the redirect URI
        NSString *code = [url.absoluteString componentsSeparatedByString:@"="][1];
        if(![code isEqualToString:@"access_denied"]) {
            [self getToken:code];
        } else {
            [self.delegate connectManager:self didFailWithError:nil];
        }
    }];
}

-(void)getToken:(NSString*)code {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"authorization_code" forKey:@"grant_type"];
    [params setObject:code forKey:@"code"];
    
    [[XeeClient sharedClient] POST:@"auth/access_token" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _accessToken = [[XeeAccessToken alloc] initWithJSON:responseObject];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"XeeSDKInternalAccessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [Xee log:@"token saved"];
        [self.delegate connectManager:self didSuccess:_accessToken];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _accessToken = nil;
        [self.delegate connectManager:self didFailWithError:error];
    }];
}

-(void)refreshToken:(void (^)(XeeAccessToken *accessToken, NSError *error))completionHandler {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"refresh_token" forKey:@"grant_type"];
    [params setObject:_accessToken.refresh_token forKey:@"refresh_token"];
    
    _accessToken = nil;
    
    [[XeeClient sharedClient] POST:@"auth/access_token" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _accessToken = [[XeeAccessToken alloc] initWithJSON:responseObject];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"XeeSDKInternalAccessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [Xee log:@"token saved"];
        completionHandler(_accessToken, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _accessToken = nil;
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"XeeSDKInternalAccessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [Xee log:@"token cleared"];
        completionHandler(nil, error);
    }];
}

-(void)disconnect {
    _accessToken = nil;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"XeeSDKInternalAccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
    
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"window.alert=null;"];
}

@end
