//
//  ItemCommunicatorDelegate.h
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ItemCommunicatorDelegate <NSObject>

-(void)receivedItemJSON:(NSData *)objectNotation;

-(void)fetchingItemFailedWithError:(NSError *)error;

@end
