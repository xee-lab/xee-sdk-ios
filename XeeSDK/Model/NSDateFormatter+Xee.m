//
//  NSDateFormatter+Xee.m
//  Pods
//
//  Created by Jean-Baptiste Dujardin on 03/05/2017.
//
//

#import "NSDateFormatter+Xee.h"

@implementation NSDateFormatter (Xee)

+ (instancetype)RFC3339DateFormatter {
    
    static NSDateFormatter *rfc3339DateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rfc3339DateFormatter = [NSDateFormatter new];
        //[rfc3339DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        [rfc3339DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSXXX"];
        [rfc3339DateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });
    
    return rfc3339DateFormatter;
    
}
    
@end
