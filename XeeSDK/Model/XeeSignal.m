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

#import "XeeSignal.h"

@implementation XeeSignal

-(instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super initWithJSON:JSON];
    if (self) {
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            _name = [JSON objectForKey:@"name"];
            _value = [JSON objectForKey:@"value"];
            _date = [[NSDateFormatter RFC3339DateFormatter] dateFromString:[JSON objectForKey:@"date"]];
        }
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"\
            name: %@\r\
            value: %@\r\
            date: %@",
            _name, _value, _date];
}

@end
