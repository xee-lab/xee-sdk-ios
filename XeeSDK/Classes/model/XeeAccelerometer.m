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

#import "XeeAccelerometer.h"

@implementation XeeAccelerometer

-(instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super initWithJSON:JSON];
    if (self) {
        if(JSON != [NSNull null]) {
            _x = (int)[[JSON objectForKey:@"x"] integerValue];
            _y = (int)[[JSON objectForKey:@"y"] integerValue];
            _z = (int)[[JSON objectForKey:@"z"] integerValue];
            _date = dateWithRFC3339([JSON objectForKey:@"date"]);
        }
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"\
            x: %d\r\
            y: %d\r\
            z: %d\r\
            date: %@",
            _x, _y, _z, _date];
}

@end
