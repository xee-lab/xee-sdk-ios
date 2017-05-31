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

#import "XeeCarStatus.h"

@implementation XeeCarStatus

- (instancetype)init
    {
        self = [super init];
        if (self) {
        }
        return self;
    }
    
-(instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super initWithJSON:JSON];
    if (self) {
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            if ([JSON objectForKey:@"accelerometer"]) {
                _accelerometer = [XeeAccelerometer withJSON:[JSON objectForKey:@"accelerometer"]];
            }
            if ([JSON objectForKey:@"location"]) {
                _location = [XeeLocation withJSON:[JSON objectForKey:@"location"]];
            }
            if ([JSON objectForKey:@"signals"]) {
                NSMutableArray *signals = [NSMutableArray array];
                for(NSDictionary *signalJSON in [JSON objectForKey:@"signals"]) {
                    [signals addObject:[XeeSignal withJSON:signalJSON]];
                }
                _signals = signals;
            }
        }
    }
    return self;
}

-(XeeSignal*)getSignalWithName:(NSString*)name {
    for(XeeSignal *signal in self.signals) {
        if([signal.name isEqualToString:name]) {
            return signal;
        }
    }
    return nil;
}


-(NSString *)description {
    return [NSString stringWithFormat:@"\
            accelerometer: %@\r\
            location: %@\r\
            signals: %@",
            _accelerometer, _location, _signals];
}

@end