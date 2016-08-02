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

#import "XeeHTTPClient.h"
#import "Xee.h"

@implementation XeeHTTPClient

-(NSURLSessionDataTask *)method:(NSString *)method urlString:(NSString*)urlString params:(NSDictionary *)params headers:(NSDictionary *)headers completionHandler:(void (^)(NSData *, NSArray<XeeError *> *))completionHandler {
    
    if(![Xee connectManager].config) {
        XeeError *configError = [[XeeError alloc] init];
        configError.type = @"CONFIG_ERROR";
        configError.message = @"Configuration not found";
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil, @[configError]);
        });
        return nil;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // create the URL
    NSString *environmentURL = [Xee connectManager].config.environmentURLString;
    NSString *completeURLString = [NSString stringWithFormat:@"%@%@", environmentURL, urlString];
    NSURL *url = [NSURL URLWithString:completeURLString];
    // create the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // configure the method of the request
    request.HTTPMethod = method;
    // configure the body with the params parameter
    request.HTTPBody = [self createHTTPBodyWithDictionary:params];
    // configure the headers with the headers parameter
    for(NSString *key in headers) {
        [request addValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
    // return the session data task
    return [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // if there's a network error
        if(error) {
            XeeError *networkError = [[XeeError alloc] init];
            networkError.message = error.description;
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil, @[networkError]);
            });
        }
        else {
            // if there's an api error
            if(((NSHTTPURLResponse*)response).statusCode != 200) {
                // create the array of errors from the JSON response
                NSMutableArray *errors = [NSMutableArray array];
                id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                if([json isKindOfClass:[NSArray class]]) {
                    for(NSDictionary *errorJson in json) {
                        [errors addObject:[XeeError withJSON:errorJson]];
                    }
                } else {
                    [errors addObject:[XeeError withJSON:json]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(data, [NSArray arrayWithArray:errors]);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(data, nil);
                });
            }
        }
    }];
}

-(NSData*)createHTTPBodyWithDictionary:(NSDictionary*)dictionary {
    return [[self createHTTPParamsWithDictionary:dictionary] dataUsingEncoding:NSUTF8StringEncoding];
}

-(NSString*)createHTTPParamsWithDictionary:(NSDictionary*)dictionary {
    NSString *HTTPParamsString = @"";
    int i = 0;
    for(NSString *key in dictionary) {
        HTTPParamsString = [HTTPParamsString stringByAppendingString:[NSString stringWithFormat:@"%@=%@%@", key, [dictionary objectForKey:key], i == dictionary.count - 1 ? @"" : @"&"]];
        i++;
    }
    return HTTPParamsString;
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

-(NSString*)createURLEncodedStringWithCommaWithArray:(NSArray*)array {
    NSString *urlEncoded = @"";
    int i = 0;
    for(NSString *string in array) {
        urlEncoded = [urlEncoded stringByAppendingString:[NSString stringWithFormat:@"%@%@", string, i == array.count - 1 ? @"" : @","]];
        i++;
    }
    urlEncoded = [urlEncoded stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlEncoded;
}

+(XeeHTTPClient *)client {
    return [[XeeHTTPClient alloc] init];
}

@end
