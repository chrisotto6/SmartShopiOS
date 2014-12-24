//
//  ItemBuilder.h
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemBuilder : NSObject

+ (NSArray *)itemFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end
