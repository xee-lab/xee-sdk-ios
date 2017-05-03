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

@interface XeeConnectManager () {
    UIWebView *embeddedWV;
    XeeHTTPClient *client;
}

@end

@implementation XeeConnectManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createWebView];
        client = [[XeeHTTPClient alloc] init];
        NSDictionary *json = [[NSUserDefaults standardUserDefaults] objectForKey:@"XeeSDKInternalAccessToken"];
        if(json)
            _accessToken = [[XeeAccessToken alloc] initWithJSON:json];
    }
    return self;
}

-(void)createWebView {
    embeddedWV = [[UIWebView alloc] init];
}

-(void)showWebViewInView:(UIView *)view WithURL:(NSURL *)url {
    CGRect frame = view.bounds;
    frame.origin.y = frame.size.height;
    embeddedWV.frame = frame;
    frame.origin.y = 0;
    [embeddedWV loadRequest:[NSURLRequest requestWithURL:url]];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(8.0, 28.0, frame.size.width / 4.0, 40.0)];
    [cancelButton setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor whiteColor]];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [embeddedWV addSubview:cancelButton];
    [view addSubview:embeddedWV];
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        embeddedWV.frame = frame;
    } completion:nil];
}

-(void)cancel {
    CGRect frame = embeddedWV.frame;
    frame.origin.y = frame.size.height;
    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        embeddedWV.frame = frame;
    } completion:^(BOOL finished) {
        [embeddedWV removeFromSuperview];
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
        [self refreshToken:^(XeeAccessToken *accessToken, NSArray<XeeError *> *errors) {
            if(!errors) {
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
                [self.delegate connectManager:self didFailWithErrors:errors];
            }
        }];
    // else show the auth page in safari
    } else {
        [self showAuthPage];
    }
}

-(void)showRegisterPage {
    [Xee log:@"show register page"];
    
    NSString *urlEncodedScopes = [client createURLEncodedStringWithArray:_config.scopes];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@auth/register?client_id=%@&redirect_uri=%@&scope=%@", self.config.environmentURLString, _config.clientID, _config.redirectURI, urlEncodedScopes]];
    
    UIView *view = [self.delegate connectManagerViewForSignUp];
    [self showWebViewInView:view WithURL:url];
}

-(void)showAuthPage {
    [Xee log:@"show auth page"];
    
    NSString *urlEncodedScopes = [client createURLEncodedStringWithArray:_config.scopes];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@auth/auth?client_id=%@&redirect_uri=%@&scope=%@", self.config.environmentURLString, _config.clientID, _config.redirectURI, urlEncodedScopes]];
    
    UIView *view = [self.delegate connectManagerViewForLogin];
    [self showWebViewInView:view WithURL:url];
}

-(void)openURL:(NSURL*)url {
    CGRect frame = embeddedWV.frame;
    frame.origin.y = frame.size.height;
    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        embeddedWV.frame = frame;
    } completion:^(BOOL finished) {
        [embeddedWV removeFromSuperview];
        // gete the code from the redirect URI
        NSString *code = [url.absoluteString componentsSeparatedByString:@"="][1];
        if(![code isEqualToString:@"access_denied"]) {
            [self getToken:code];
        } else {
            [self.delegate connectManager:self didFailWithErrors:nil];
        }
    }];
}

-(void)getToken:(NSString*)code {
    NSData *credentialData = [[NSString stringWithFormat:@"%@:%@", _config.clientID, _config.secretKey] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Credentials = @"Basic ";
    base64Credentials = [base64Credentials stringByAppendingString:[credentialData base64EncodedStringWithOptions:0]];
    NSString *urlString = @"auth/access_token";
    NSDictionary *params = @{@"grant_type":@"authorization_code", @"code":code};
    NSDictionary *headers = @{@"Authorization":base64Credentials,@"Content-Type":@"application/x-www-form-urlencoded"};
    [[client method:@"POST" urlString:urlString params:params headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        _accessToken = nil;
        if(errors.count == 0) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]
            ;
            _accessToken = [[XeeAccessToken alloc] initWithJSON:json];
            [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"XeeSDKInternalAccessToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [Xee log:@"token saved"];
            [self.delegate connectManager:self didSuccess:_accessToken];
        } else {
            [self.delegate connectManager:self didFailWithErrors:errors];
        }
    }] resume];
}

-(void)refreshToken:(void (^)(XeeAccessToken *accessToken, NSArray<XeeError *> *errors))completionHandler {
    NSData *credentialData = [[NSString stringWithFormat:@"%@:%@", _config.clientID, _config.secretKey] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Credentials = @"Basic ";
    base64Credentials = [base64Credentials stringByAppendingString:[credentialData base64EncodedStringWithOptions:0]];
    NSString *urlString = @"auth/access_token";
    NSDictionary *params = @{@"grant_type":@"refresh_token", @"refresh_token":_accessToken.refresh_token};
    NSDictionary *headers = @{@"Authorization":base64Credentials,@"Content-Type":@"application/x-www-form-urlencoded"};
    [[client method:@"POST" urlString:urlString params:params headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        _accessToken = nil;
        if(errors.count == 0) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]
            ;
            _accessToken = [[XeeAccessToken alloc] initWithJSON:json];
            [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"XeeSDKInternalAccessToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [Xee log:@"token saved"];
            completionHandler(_accessToken, nil);
        } else {
            _accessToken = nil;
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"XeeSDKInternalAccessToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [Xee log:@"token cleared"];
            completionHandler(nil, errors);
        }
    }] resume];
}

-(NSData*)createBodyWithParams:(NSDictionary*)params {
    NSString *data = @"";
    for(NSString *key in params) {
        data = [data stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, [params objectForKey:key]]];
    }
    return [data dataUsingEncoding:NSUTF8StringEncoding];
}

-(void)disconnect {
    _accessToken = nil;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"XeeSDKInternalAccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end