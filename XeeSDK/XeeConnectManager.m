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
#import "globals.h"

@interface XeeConnectManager () {
    void (^savedCompletionHandler)(XeeAccessToken *, NSArray<XeeError *> *);
    XeeHTTPClient *client;
}

@end

@implementation XeeConnectManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        client = [[XeeHTTPClient alloc] init];
        NSDictionary *json = [[NSUserDefaults standardUserDefaults] objectForKey:@"XeeSDKInternalAccessToken"];
        if(json)
            _accessToken = [[XeeAccessToken alloc] initWithJSON:json];
    }
    return self;
}

-(void)connect:(void (^)(XeeAccessToken *, NSArray<XeeError *> *))completionHandler {
    // keep the completion handler in memory
    savedCompletionHandler = completionHandler;
    // if there's an access token
    if(_accessToken) {
        // try to refresh the access token
        [self refreshToken:^(XeeAccessToken *accessToken, NSArray<XeeError *> *errors) {
            // got a new access token, call the handler directly
            if(accessToken)
                completionHandler(_accessToken, nil);
            // else, show the auth page in safari
            else
                [self showAuthPage];
        }];
    // else show the auth page in safari
    } else {
        [self showAuthPage];
    }
}

-(void)showAuthPage {
    NSString *urlEncodedScopes = [client createURLEncodedStringWithArray:_config.scopes];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@auth/auth?client_id=%@&redirect_uri=%@&scope=%@", self.config.environmentURLString, _config.clientID, _config.redirectURI, urlEncodedScopes]];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)openURL:(NSURL*)url {
    // gete the code from the redirect URI
    NSString *code = [url.absoluteString componentsSeparatedByString:@"="][1];
    [self getToken:code];
}

-(void)getToken:(NSString*)code {
    // if we don't have the completion handler in memory so ignore
    if(!savedCompletionHandler)
        return;
    
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
        }
        savedCompletionHandler(_accessToken, errors);
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
        }
        completionHandler(_accessToken, errors);
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
