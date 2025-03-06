//
//  SHState.h
//  Nocta
//
//  Created by Ali.cpp on 4/10/15.
//  Copyright (c) 2015 Ali Mahouk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

@interface SHState : NSObject

@property (nonatomic) SHAction state;
@property (nonatomic) id value;
@property (nonatomic) BOOL biased;

- (id)initWithState:(int)state value:(id)value;

@end
