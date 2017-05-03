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

#import <Foundation/Foundation.h>

typedef enum XeeEnvironmentTypes {
    XeeEnvironmentSTAGING,
    XeeEnvironmentCLOUD,
    XeeEnvironmentSANDBOX
} XeeEnvironment;

@interface XeeConfig : NSObject

@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *secretKey;

@property (nonatomic, strong) NSArray<NSString*> *scopes;

@property (nonatomic, strong) NSString *redirectURI;

@property (nonatomic, strong) NSString *userAgent;

@property (nonatomic, assign) XeeEnvironment environment;

-(NSString*)environmentURLString;

@end
