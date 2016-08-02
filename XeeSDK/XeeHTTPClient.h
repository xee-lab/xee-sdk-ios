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
#import "XeeError.h"

@interface XeeHTTPClient : NSObject

-(NSURLSessionDataTask*)method:(NSString*)method urlString:(NSString*)urlString params:(NSDictionary*)params headers:(NSDictionary*)headers completionHandler:(void (^)(NSData *data, NSArray<XeeError*> *errors))completionHandler;

+(XeeHTTPClient*)client;

-(NSString*)createHTTPParamsWithDictionary:(NSDictionary*)dictionary;
-(NSData*)createHTTPBodyWithDictionary:(NSDictionary*)dictionary;
-(NSString*)createURLEncodedStringWithArray:(NSArray*)array;
-(NSString*)createURLEncodedStringWithCommaWithArray:(NSArray*)array;

@end
