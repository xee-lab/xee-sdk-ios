//
//  XeeClient.h
//  Pods
//
//  Created by Jean-Baptiste Dujardin on 04/05/2017.
//
//

#import <AFNetworking/AFNetworking.h>

@interface XeeClient : AFHTTPSessionManager
    
+ (id)sharedClient;

@end
