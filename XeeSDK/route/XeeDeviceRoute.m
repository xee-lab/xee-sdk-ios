//
//  XeeDeviceRoute.m
//  XeeSDK
//
//  Created by Anthony Pauriche on 22/08/2016.
//  Copyright © 2016 Eliocity. All rights reserved.
//

#import "XeeDeviceRoute.h"

@implementation XeeDeviceRoute

-(void)signalsWithDeviceId:(NSString*)deviceId limit:(NSInteger)limit begin:(NSDate *)begin end:(NSDate *)end name:(NSArray<NSString *> *)name completionHandler:(void (^)(NSArray<XeeSignal *> *, NSArray<XeeError *> *))completionHandler {
    NSString *beginString = stringWithRFC3339Date(begin);
    NSString *endString = stringWithRFC3339Date(end);
    NSString *nameString = [client createURLEncodedStringWithCommaWithArray:name];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(limit != 0) {
        [dic setValue:@(limit) forKey:@"limit"];
    }
    if(![beginString isEqualToString:@""]) {
        [dic setValue:beginString forKey:@"begin"];
    }
    if(![endString isEqualToString:@""]) {
        [dic setValue:endString forKey:@"end"];
    }
    if(![nameString isEqualToString:@""]) {
        [dic setValue:nameString forKey:@"name"];
    }
    NSString *params = [client createHTTPParamsWithDictionary:dic];
    NSString *urlString = [NSString stringWithFormat:@"devices/%@/signals%@%@", deviceId, dic.count > 0 ? @"?" : @"", params];
    NSDictionary *headers = [self configureHeader];
    [[client method:@"GET" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        if(!errors) {
            NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSMutableArray *signals = [NSMutableArray array];
            for(NSDictionary *signalJSON in JSON) {
                [signals addObject:[XeeSignal withJSON:signalJSON]];
            }
            completionHandler(signals, errors);
        } else {
            completionHandler(nil, errors);
        }
    }] resume];
}

@end
