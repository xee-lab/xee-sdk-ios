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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = @"Unknown error";
        self.message = @"Unknown error";
        self.tip = @"Unknown error";
    }
    return self;
}

-(instancetype)initWithJSON:(NSDictionary*)json {
    self = [self init];
    if(self) {
        if([json objectForKey:@"type"]) {
            self.type = [json objectForKey:@"type"];
        }
        if([json objectForKey:@"message"]) {
            self.message = [json objectForKey:@"message"];
            if ([self.message isEqualToString:@"Please light a candle and pray for our devops"]) {
                NSBundle *bundle = [NSBundle bundleForClass:[self class]];
                self.message = NSLocalizedStringFromTableInBundle(@"default_error", @"local", bundle, @"");
            }
        }
        if([json objectForKey:@"tip"]) {
            self.tip = [json objectForKey:@"tip"];
        }
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
