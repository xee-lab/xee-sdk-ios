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

#import "XeeError.h"

@implementation XeeError

-(instancetype)initWithJSON:(NSDictionary*)json {
    self = [super init];
    if(self) {
        self.type = [json objectForKey:@"type"];
        self.message = [json objectForKey:@"message"];
        self.tip = [json objectForKey:@"tip"];
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"\
            type: %@\r\
            message: %@\r\
            tip: %@",
            _type, _message, _tip];
}

@end
