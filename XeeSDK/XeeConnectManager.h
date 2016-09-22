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

#import <UIKit/UIKit.h>
#import "XeeConfig.h"
#import "XeeAccessToken.h"
#import "XeeHTTPClient.h"

@protocol XeeConnectManagerDelegate <NSObject>

@optional
-(void)connectManagerConnectWillShowOAuthPage;
@required
-(void)connectManagerConnectSuccess:(XeeAccessToken*)accessToken;
-(void)connectManagerConnectErrors:(NSArray<XeeError*>*)errors;

@end

@interface XeeConnectManager : NSObject

@property (nonatomic, strong) XeeAccessToken *accessToken;
@property (nonatomic, strong) XeeConfig *config;

@property (nonatomic, weak) id<XeeConnectManagerDelegate> delegate;

/*!
 Invalid the access token
 */
-(void)disconnect;

/*!
 Authenticate the user. If a valid access token already exists, the completionHandler is called. If not, safari will open and show the log in form.
 */
-(void)connect;
-(void)openURL:(NSURL*)url;

@end
