//
//  SHState.m
//  Nocta
//
//  Created by Ali.cpp on 4/10/15.
//  Copyright (c) 2015 Ali Mahouk. All rights reserved.
//

#import "SHState.h"

@implementation SHState

- (id)initWithState:(int)state value:(id)value
{
    self = [super init];
    
    if ( self )
    {
        _state = state;
        _value = value;
        
        _biased = NO;
    }
    
    return self;
}

@end
