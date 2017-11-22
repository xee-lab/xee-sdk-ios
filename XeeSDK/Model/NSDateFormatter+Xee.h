//
//  NSDateFormatter+Xee.h
//  Pods
//
//  Created by Jean-Baptiste Dujardin on 03/05/2017.
//
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Xee)

+ (instancetype)RFC3339DateFormatter;

+ (instancetype)RFC3339DateFormatterWithMS;

+ (NSDate *)xeeDateFromString:(NSString *)string;

+ (NSString *)xeeStringFromDate:(NSDate *)date;
    
@end
