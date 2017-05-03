//
//  XeeDevice.m
//  XeeSDK
//
//  Created by Jean-Baptiste Dujardin on 26/04/2017.
//  Copyright © 2017 Eliocity. All rights reserved.
//

#import "XeeDevice.h"

@implementation XeeDevice

-(instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super initWithJSON:JSON];
    if (self) {
        _xeeId = [JSON objectForKey:@"xeeId"];
        _status = (int)[[JSON objectForKey:@"status"] integerValue];
        _associationAttempts = (int)[[JSON objectForKey:@"associationAttempts"] integerValue];
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"\
            xeeId: %@\r\
            status: %d\r\
            associationAttempts: %d",
            _xeeId, _status, _associationAttempts];
    return nil;
}

@end
