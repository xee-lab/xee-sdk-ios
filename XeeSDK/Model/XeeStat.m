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

#import "XeeStat.h"

@implementation XeeStat

-(instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super initWithJSON:JSON];
    if(self) {
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            _beginDate = [NSDateFormatter xeeDateFromString:[JSON objectForKey:@"beginDate"]];
            _endDate = [NSDateFormatter xeeDateFromString:[JSON objectForKey:@"endDate"]];
            
            _type = [JSON objectForKey:@"type"];
            
            _value = [JSON objectForKey:@"value"];
        }
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"\
            beginDate: %@\r\
            endDate: %@\r\
            type: %@\r\
            value: %@",
            _beginDate, _endDate, _type, _value];
}

@end
