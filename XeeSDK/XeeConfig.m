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

#import "XeeConfig.h"

@implementation XeeConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.environment = XeeEnvironmentCLOUD;
        self.userAgent = @"SDK Xee";
    }
    return self;
}

-(NSString*)environmentURLString {
    switch (self.environment) {
        case XeeEnvironmentSTAGING:
            return @"https://staging.xee.com/v3/";
            break;
        case XeeEnvironmentCLOUD:
            return @"https://cloud.xee.com/v3/";
            break;
        case XeeEnvironmentSANDBOX:
            return @"https://sandbox.xee.com/v3/";
            break;
        default:
            break;
    }
    return @"";
}

@end