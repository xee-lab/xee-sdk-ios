//
//  XeeClient.m
//  Pods
//
//  Created by Jean-Baptiste Dujardin on 04/05/2017.
//
//

#import "XeeClient.h"
#import "Xee.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "NSDictionary+Xee.h"
#import "NSArray+Xee.h"

@implementation XeeClient

+ (id)sharedClient {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
    
-(instancetype)init {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setTimeoutIntervalForRequest:10.0];
    self = [super initWithBaseURL:[NSURL URLWithString:[Xee connectManager].config.environmentURLString] sessionConfiguration:config];
    if(!self) return nil;
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    return self;
}
    
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    if ([URLString isEqualToString:@"auth/access_token"]) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self.requestSerializer setAuthorizationHeaderFieldWithUsername:Xee.connectManager.config.clientID password:Xee.connectManager.config.secretKey];
    }else {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer clearAuthorizationHeader];
    }
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    if ([Xee connectManager].accessToken.access_token && [Xee connectManager].config.userAgent) {
        [request setValue:[NSString stringWithFormat:@"Bearer %@", [Xee connectManager].accessToken.access_token] forHTTPHeaderField:@"Authorization"];
        [request setValue:[Xee connectManager].config.userAgent forHTTPHeaderField:@"User-Agent"];
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if ([responseObject isKindOfClass:[NSDictionary class]]) {
                               responseObject = [responseObject dictionaryByReplacingNullsWithBlanks];
                           }else if ([responseObject isKindOfClass:[NSArray class]]) {
                               responseObject = [responseObject arrayByReplacingNullsWithBlanks];
                           }
                           if (error) {
                               if (failure) {
                                   if ([responseObject isKindOfClass:[NSArray class]] && [responseObject count] > 0) {
                                       NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : [responseObject firstObject][@"message"] };
                                       failure(dataTask, [NSError errorWithDomain:[responseObject firstObject][@"type"]
                                                                             code:[(NSHTTPURLResponse *)response statusCode]
                                                                         userInfo:userInfo]);
                                   }else {
                                       failure(dataTask, error);
                                   }
                               }
                           } else {
                               if (success) {
                                   success(dataTask, responseObject);
                               }
                           }
                       }];
    
    return dataTask;
    
}
    
@end
