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
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            _xeeId = [JSON objectForKey:@"xeeId"];
            _status = [JSON objectForKey:@"status"];
            _associationAttempts = [JSON objectForKey:@"associationAttempts"];
        }
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"\
            xeeId: %@\r\
            status: %@\r\
            associationAttempts: %@",
            _xeeId, _status, _associationAttempts];
    return nil;
}

@end
