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

#ifndef globals_h
#define globals_h

static NSDate* dateWithRFC3339(NSString *string) {
    NSDate *date;
    if(![string isKindOfClass:[NSNull class]]) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSXXX";
        df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        date = [df dateFromString:string];
        if(nil == date) {
            df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
            date = [df dateFromString:string];
        }
    }
    return date;
}

static NSString* stringWithRFC3339Date(NSDate *date) {
    if(date) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
        df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        return [df stringFromDate:date];
    }
    return @"";
}

#endif /* globals_h */
